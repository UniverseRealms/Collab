﻿using Mono.Game;
using System;
using wServer.realm;
using wServer.realm.cores;

namespace wServer.logic.behaviors
{
    public class MoveTo2 : Behavior
    {
        private readonly float speed;
        private readonly float baseX;
        private readonly float baseY;
        private readonly bool isMapPosition;
        private readonly bool instant;
        private bool once;
        private bool returned;
        private float X;
        private float Y;

        public MoveTo2(float X, float Y, double speed = 2, bool once = false, bool isMapPosition = false, bool instant = false)
        {
            this.isMapPosition = isMapPosition;
            this.speed = (float)speed;
            this.once = once;
            this.instant = instant;
            baseX = X;
            baseY = Y;
        }

        protected override void OnStateEntry(Entity host, ref object state)
        {
            if (!isMapPosition)
            {
                X = baseX + host.X;
                Y = baseY + host.Y;
            }
            else
            {
                X = baseX;
                Y = baseY;
            }

            if (instant)
            {
                host.Move(X, Y);
            }
        }

        protected override void TickCore(Entity host, ref object state)
        {
            if (instant)
                return;
            if (!returned)
            {
                var spd = host.GetSpeed(speed) * (CoreConstant.worldLogicTickMs / 1000f);

                if (Math.Abs(X - host.X) > 0.5 || Math.Abs(Y - host.Y) > 0.5)
                {
                    Vector2 vect = new Vector2(X, Y) - new Vector2(host.X, host.Y);
                    vect.Normalize();
                    vect *= spd;
                    host.Move(host.X + vect.X, host.Y + vect.Y);

                    if (host.X == X && host.Y == Y && once)
                    {
                        once = true;
                        returned = true;
                    }
                }
            }
        }
    }
}
