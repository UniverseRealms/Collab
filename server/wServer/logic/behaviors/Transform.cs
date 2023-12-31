﻿using common.resources;
using wServer.realm;
using wServer.realm.entities;

namespace wServer.logic.behaviors
{
    internal class Transform : Behavior
    {
        //State storage: none

        private ushort target;

        public Transform(string target)
        {
            this.target = GetObjType(target);
        }

        protected override void TickCore(Entity host, ref object state)
        {
            Entity entity = Entity.Resolve(host.Manager, target);
            if (entity is Portal
              && host.Owner.Name.Contains("Arena"))
            {
                return;
            }
            entity.Move(host.X, host.Y);

            if (host is Enemy && entity is Enemy && (host as Enemy).Spawned)
            {
                (entity as Enemy).Spawned = true;
            }

            host.Owner.EnterWorld(entity);
            host.Owner.LeaveWorld(host);
        }
    }
}
