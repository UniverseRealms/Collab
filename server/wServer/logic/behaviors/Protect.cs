﻿using common.resources;
using Mono.Game;
using wServer.realm;
using wServer.realm.cores;

namespace wServer.logic.behaviors
{
    internal class Protect : CycleBehavior
    {
        //State storage: protect state
        private enum ProtectState
        {
            DontKnowWhere,
            Protecting,
            Protected,
        }

        private float speed;
        private ushort protectee;
        private float acquireRange;
        private float protectionRange;
        private float reprotectRange;

        public Protect(double speed, string protectee, double acquireRange = 10, double protectionRange = 2, double reprotectRange = 1)
        {
            this.speed = (float)speed;
            this.protectee = GetObjType(protectee);
            this.acquireRange = (float)acquireRange;
            this.protectionRange = (float)protectionRange;
            this.reprotectRange = (float)reprotectRange;
        }

        protected override void TickCore(Entity host, ref object state)
        {
            ProtectState s;
            if (state == null) s = ProtectState.DontKnowWhere;
            else s = (ProtectState)state;

            Status = CycleStatus.NotStarted;

            if (host.HasConditionEffect(ConditionEffects.Paralyzed))
                return;

            var entity = host.GetNearestEntity(acquireRange, protectee);
            Vector2 vect;
            switch (s)
            {
                case ProtectState.DontKnowWhere:
                    if (entity != null)
                    {
                        s = ProtectState.Protecting;
                        goto case ProtectState.Protecting;
                    }
                    break;

                case ProtectState.Protecting:
                    if (entity == null)
                    {
                        s = ProtectState.DontKnowWhere;
                        break;
                    }
                    vect = new Vector2(entity.X - host.X, entity.Y - host.Y);
                    if (vect.Length() > reprotectRange)
                    {
                        Status = CycleStatus.InProgress;
                        vect.Normalize();
                        float dist = host.GetSpeed(speed) * (CoreConstant.worldLogicTickMs / 1000f);
                        host.ValidateAndMove(host.X + vect.X * dist, host.Y + vect.Y * dist);
                    }
                    else
                    {
                        Status = CycleStatus.Completed;
                        s = ProtectState.Protected;
                    }
                    break;

                case ProtectState.Protected:
                    if (entity == null)
                    {
                        s = ProtectState.DontKnowWhere;
                        break;
                    }
                    Status = CycleStatus.Completed;
                    vect = new Vector2(entity.X - host.X, entity.Y - host.Y);
                    if (vect.Length() > protectionRange)
                    {
                        s = ProtectState.Protecting;
                        goto case ProtectState.Protecting;
                    }
                    break;
            }

            state = s;
        }
    }
}
