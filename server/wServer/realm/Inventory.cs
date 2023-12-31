﻿using common;
using common.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using wServer.realm.entities;

namespace wServer.realm
{
    public interface IContainer
    {
        int[] SlotTypes { get; }
        Inventory Inventory { get; }
        RInventory DbLink { get; }
    }

    public class InventoryChangedEventArgs : EventArgs
    {
        //index = -1 -> reset
        public InventoryChangedEventArgs(Item[] old, Item[] @new)
        {
            OldItems = old;
            NewItems = @new;
        }

        public Item[] OldItems { get; private set; }
        public Item[] NewItems { get; private set; }
    }

    public class InventoryTransaction : IEnumerable<Item>
    {
        private readonly IContainer _parent;
        private readonly Item[] _originalItems;
        private readonly Item[] _changedItems;

        public int Length => _originalItems.Length;

        public InventoryTransaction(IContainer parent)
        {
            _parent = parent;
            _originalItems = parent.Inventory.GetItems();
            _changedItems = (Item[])_originalItems.Clone();
        }

        public bool Validate(bool revert = false)
        {
            if (_parent == null)
                return false;

            var items = revert ? _changedItems : _originalItems;

            for (var i = 0; i < items.Length; i++)
                if (items[i] != _parent.Inventory[i])
                    return false;

            return true;
        }

        public void Execute()
        {
            var inv = _parent.Inventory;
            for (var i = 0; i < inv.Length; i++)
                if (_originalItems[i] != _changedItems[i])
                    inv[i] = _changedItems[i];
        }

        public void Revert()
        {
            var inv = _parent.Inventory;
            for (var i = 0; i < inv.Length; i++)
                if (_originalItems[i] != _changedItems[i])
                    inv[i] = _originalItems[i];
        }

        public int GetAvailableInventorySlot(Item item)
        {
            var plr = _parent as Player;
            if (plr != null)
            {
                var playerDesc = plr.Manager.Resources.GameData
                    .Classes[plr.ObjectDesc.ObjectType];
                for (var i = 0; i < 4; i++)
                    if (_changedItems[i] == null && playerDesc.SlotTypes[i] == item.SlotType)
                        return i;

                for (var i = 4; i < 12 || (plr.HasBackpack && i < plr.Inventory.Length); i++)
                    if (_changedItems[i] == null)
                        return i;
            }
            else
            {
                for (var i = 0; i < 8; i++)
                    if (_changedItems[i] == null)
                        return i;
            }

            return -1;
        }

        public IEnumerator<Item> GetEnumerator() => ((IEnumerable<Item>)_changedItems).GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => _changedItems.GetEnumerator();

        public Item this[int index]
        {
            get { return _changedItems[index]; }
            set { _changedItems[index] = value; }
        }
    }

    public class InventoryItems
    {
        private readonly SV<int>[] _itemTypes;
        private readonly Item[] _items;

        public int Length => _items.Length;

        public InventoryItems(IContainer container, Item[] items)
        {
            _itemTypes = new SV<int>[items.Length];
            _items = new Item[items.Length];

            for (var i = 0; i < items.Length; i++)
            {
                var sti = (int)StatsType.Inventory0 + i;
                if (i >= 12)
                    sti = (int)StatsType.BackPack0 + i - 12;

                _itemTypes[i] = new SV<int>(
                    container as Entity,
                    (StatsType)sti, items[i]?.ObjectType ?? -1,
                    container is Player && i > 3);
                _items[i] = items[i];
            }
        }

        public void SetItems(Item[] items)
        {
            if (items.Length > Length)
                throw new InvalidOperationException("Item array must be <= the size of the initialized array.");

            for (var i = 0; i < items.Length; i++)
            {
                _itemTypes[i].SetValue(items[i]?.ObjectType ?? -1);
                _items[i] = items[i];
            }
        }

        public Item[] GetItems() => _items.Clone() as Item[];

        public Item this[int index]
        {
            get { return _items[index]; }
            set
            {
                _itemTypes[index].SetValue(value?.ObjectType ?? -1);
                _items[index] = value;
            }
        }
    }

    public class Inventory : IEnumerable<Item>
    {
        private readonly object _invLock = new object();
        private readonly IContainer _parent;

        private readonly InventoryItems _items;

        public event EventHandler<InventoryChangedEventArgs> InventoryChanged;

        public IContainer Parent => _parent;
        public int Length => _items.Length;

        public Inventory(IContainer parent) : this(parent, new Item[Program.Resources.Settings.InventorySize]) { }

        public Inventory(IContainer parent, Item[] items)
        {
            _parent = parent;
            _items = new InventoryItems(parent, items);
        }

        public void SetItems(Item[] items)
        {
            if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                try
                {
                    var oItems = _items.GetItems();
                    _items.SetItems(items);
                    InventoryChanged?.Invoke(this, new InventoryChangedEventArgs(oItems, _items.GetItems()));
                }
                finally { Monitor.Exit(_invLock); }
        }

        public void SetItems(IEnumerable<ushort> items)
        {
            if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                try
                {
                    var oItems = _items.GetItems();
                    _items.SetItems(ConvertObjectType2ItemArray(items));
                    InventoryChanged?.Invoke(this, new InventoryChangedEventArgs(oItems, _items.GetItems()));
                }
                finally { Monitor.Exit(_invLock); }
        }

        public Item[] GetItems()
        {
            if (Monitor.TryEnter(TrySaveLock, new TimeSpan(0, 0, 1)))
                try
                {
                    if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                        try { return _items.GetItems(); }
                        finally { Monitor.Exit(_invLock); }
                }
                finally { Monitor.Exit(TrySaveLock); }

            return default;
        }

        public ushort[] GetItemTypes()
        {
            if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                try { return _items.GetItems().Select(_ => _?.ObjectType ?? 0xffff).ToArray(); }
                finally { Monitor.Exit(_invLock); }

            return default;
        }

        public Item this[int index]
        {
            get
            {
                if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                    try { return _items[index]; }
                    finally { Monitor.Exit(_invLock); }

                return default;
            }
            set
            {
                if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                    try
                    {
                        if (_items[index] != value)
                        {
                            var oItems = _items.GetItems();
                            _items[index] = value;
                            InventoryChanged?.Invoke(this, new InventoryChangedEventArgs(oItems, _items.GetItems()));
                        }
                    }
                    finally { Monitor.Exit(_invLock); }
            }
        }

        public InventoryTransaction CreateTransaction() => new InventoryTransaction(Parent);

        private static readonly object TrySaveLock = new object();

        public static bool Execute(params InventoryTransaction[] transactions)
        {
            if (Monitor.TryEnter(TrySaveLock, new TimeSpan(0, 0, 1)))
                try
                {
                    if (transactions.Any(tranaction => !tranaction.Validate())) return false;
                    else
                    {
                        foreach (var transcation in transactions) transcation.Execute();

                        return true;
                    }
                }
                finally { Monitor.Exit(TrySaveLock); }

            return default;
        }

        public static bool Revert(params InventoryTransaction[] transactions)
        {
            if (Monitor.TryEnter(TrySaveLock, new TimeSpan(0, 0, 1)))
                try
                {
                    if (transactions.Any(tranaction => !tranaction.Validate(true))) return false;
                    else
                    {
                        foreach (var transcation in transactions) transcation.Revert();

                        return true;
                    }
                }
                finally { Monitor.Exit(TrySaveLock); }

            return default;
        }

        public int GetAvailableInventorySlot(Item item)
        {
            if (Monitor.TryEnter(_invLock, new TimeSpan(0, 0, 1)))
                try
                {
                    if (_parent is Player plr)
                    {
                        var playerDesc = plr.Manager.Resources.GameData.Classes[plr.ObjectDesc.ObjectType];

                        for (var i = 0; i < 4; i++)
                            if (_items[i] == null && playerDesc.SlotTypes[i] == item.SlotType)
                                return i;

                        for (var i = 4; i < 12 || (plr.HasBackpack && i < plr.Inventory.Length); i++)
                            if (_items[i] == null)
                                return i;
                    }
                    else
                    {
                        for (var i = 0; i < 8; i++)
                            if (_items[i] == null)
                                return i;
                    }

                    return -1;
                }
                finally { Monitor.Exit(_invLock); }

            return default;
        }

        private static Item[] ConvertObjectType2ItemArray(IEnumerable<ushort> a)
        {
            var gameData = Program.Resources.GameData;
            return a.Select(_ => (_ == 0xffff || !gameData.Items.ContainsKey(_)) ? null : gameData.Items[_]).ToArray();
        }

        public IEnumerator<Item> GetEnumerator() => ((IEnumerable<Item>)_items.GetItems()).GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => _items.GetItems().GetEnumerator();
    }
}
