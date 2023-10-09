﻿using common.resources;
using common;
using System;
using System.Collections.Generic;
using System.Linq;
using wServer.networking.packets;
using wServer.networking.packets.incoming;
using wServer.networking.packets.outgoing;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.networking.handlers
{
    internal class AcceptTradeHandler : PacketHandlerBase<AcceptTrade>
    {
        public override PacketId ID => PacketId.ACCEPTTRADE;

        protected override void HandlePacket(Client client, AcceptTrade packet)
        {
            //client.Manager.Logic.AddPendingAction(t => Handle(client, packet));
            Handle(client, packet);
        }

        private void Handle(Client client, AcceptTrade packet)
        {
            var player = client.Player;
            if (player == null || IsTest(client))
                return;

            if (player.tradeAccepted) return;

            player.trade = packet.MyOffer;
            if (player.tradeTarget.trade.SequenceEqual(packet.YourOffer))
            {
                player.tradeAccepted = true;
                player.tradeTarget.Client.SendPacket(new TradeAccepted()
                {
                    MyOffer = player.tradeTarget.trade,
                    YourOffer = player.trade
                });

                if (player.tradeAccepted && player.tradeTarget.tradeAccepted)
                {
                    if (CheckRank(player))
                    {
                        player.tradeTarget.CancelTrade();
                        player.CancelTrade();
                        player.tradeTarget.SendError("This trade is not allowed!");
                        player.SendError("This trade is not allowed!");
                        return;
                    }

                    DoTrade(player);
                }
            }
        }

        private bool CheckRank(Player player)
        {
            bool admin = (player.Client.Account.Admin != player.tradeTarget.Client.Account.Admin);
            bool rank = ((player.Rank >= 80 && player.tradeTarget.Rank < 80) || (player.Rank < 80 && player.tradeTarget.Rank >= 80));
            return (admin || rank);
        }

        private void DoTrade(Player player)
        {
            var failedMsg = "Error while trading. Trade unsuccessful.";
            var msg = "Trade Successful!";
            var thisItems = new List<Item>();
            var targetItems = new List<Item>();

            var aItem = new List<String>();
            var bItem = new List<String>();
            bool aPot = false;
            bool bPot = false;
            string name = "";

            var tradeTarget = player.tradeTarget;

            // make sure trade targets are valid
            if (tradeTarget == null || player.Owner == null || tradeTarget.Owner == null || player.Owner != tradeTarget.Owner)
            {
                TradeDone(player, tradeTarget, failedMsg);
                return;
            }

            if (!player.tradeAccepted || !tradeTarget.tradeAccepted)
                return;

            var pInvTrans = player.Inventory.CreateTransaction();
            var tInvTrans = tradeTarget.Inventory.CreateTransaction();

            for (int i = 4; i < player.trade.Length; i++)
                if (player.trade[i])
                {
                    thisItems.Add(player.Inventory[i]);

                    if (!player.Inventory[i].DisplayName.Contains("Potion of") || !player.Inventory[i].DisplayName.Contains("Vial of"))
                    {
                        aItem.Add(player.Inventory[i].DisplayName);
                    } else
                    {
                        aPot = true;
                    }
                    pInvTrans[i] = null;
                }

            for (int i = 4; i < tradeTarget.trade.Length; i++)
                if (tradeTarget.trade[i])
                {
                    targetItems.Add(tradeTarget.Inventory[i]);

                    if (!tradeTarget.Inventory[i].DisplayName.Contains("Potion of") || !tradeTarget.Inventory[i].DisplayName.Contains("Vial of"))
                    {
                        bItem.Add(tradeTarget.Inventory[i].DisplayName);
                    }
                    else
                    {
                        bPot = true;
                    }
                    tInvTrans[i] = null;
                }

            // move thisItems -> tradeTarget
            for (var i = 0; i < 12; i++)
                for (var j = 0; j < thisItems.Count; j++)
                {
                    if ((tradeTarget.SlotTypes[i] == 0 &&
                            tInvTrans[i] == null) ||
                        (thisItems[j] != null &&
                            tradeTarget.SlotTypes[i] == thisItems[j].SlotType &&
                            tInvTrans[i] == null))
                    {
                        tInvTrans[i] = thisItems[j];
                        thisItems.Remove(thisItems[j]);
                        break;
                    }
                }

            // move tradeItems -> this
            for (var i = 0; i < 12; i++)
                for (var j = 0; j < targetItems.Count; j++)
                {
                    if ((player.SlotTypes[i] == 0 &&
                            pInvTrans[i] == null) ||
                        (targetItems[j] != null &&
                            player.SlotTypes[i] == targetItems[j].SlotType &&
                            pInvTrans[i] == null))
                    {
                        pInvTrans[i] = targetItems[j];
                        targetItems.Remove(targetItems[j]);
                        break;
                    }
                }

            // save
            if (!Inventory.Execute(pInvTrans, tInvTrans))
            {
                TradeDone(player, tradeTarget, failedMsg);
                return;
            }

            // check for lingering items
            if (thisItems.Count > 0 ||
                targetItems.Count > 0)
            {
                msg = "An error occured while trading! Some items were lost!";
            }

            // trade successful, notify and save
            TradeDone(player, tradeTarget, msg);
            player.SaveToCharacter();
            player.Client.Character.FlushAsync();
            tradeTarget.SaveToCharacter();
            tradeTarget.Client.Character.FlushAsync();




            if (aItem.ToArray().Length != 0 || bItem.ToArray().Length != 0)
            {
                if (aPot) aItem.Add("Potion(s)");
                if (bPot) bItem.Add("Potion(s)");
                Program.DL.LogToDiscord(WebHooks.Trade, "Trade Log", $"[{player.Name}] traded [{string.Join(",", aItem.ToArray())}] to [{tradeTarget.Name}] for [{string.Join(",", bItem.ToArray())}]");
            }
        }

        private void TradeDone(Player player, Player tradeTarget, string msg)
        {
            player.Client.SendPacket(new TradeDone
            {
                Code = 1,
                Description = msg
            });

            if (tradeTarget != null)
            {
                tradeTarget.Client.SendPacket(new TradeDone
                {
                    Code = 1,
                    Description = msg
                });
            }
            player.ResetTrade();
        }
    }
}