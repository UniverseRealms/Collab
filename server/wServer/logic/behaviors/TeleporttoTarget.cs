﻿using Mono.Game;
using wServer.realm;

namespace wServer.logic.behaviors
{
    internal class TeleporttoTarget : CycleBehavior
    {
        private float range;

        public TeleporttoTarget(double range)
        {
            this.range = (float)range;
        }

        protected override void TickCore(Entity host, ref object state)
        {
            Status = CycleStatus.NotStarted;

            var player = host.AttackTarget ?? null;
            if (player == null)
            {
                state = CycleStatus.Completed;
                return;
            }

            Vector2 vect;
            vect = new Vector2 { X = player.X - host.X, Y = player.Y - host.Y };
            if (vect.Length() > range)
            {
                host.Move(player.X, player.Y);
                state = CycleStatus.InProgress;
            }
            else
                state = CycleStatus.Completed;
        }
    }
}
