﻿using wServer.realm;
using wServer.realm.cores;

namespace wServer.logic.transitions
{
    internal class TimedRandomTransition : Transition
    {
        //State storage: cooldown timer

        private readonly int _time;
        private readonly bool _randomized;

        public TimedRandomTransition(int time, bool randomizedTime = false, params string[] states)
            : base(states)
        {
            _time = time;
            _randomized = randomizedTime;
        }

        protected override bool TickCore(Entity host, ref object state)
        {
            int cool;

            if (state == null)
                cool = _randomized ?
                    Random.Next(_time) :
                    _time;
            else
                cool = (int)state;

            if (cool <= 0)
            {
                state = _time;
                SelectedState = Random.Next(TargetStates.Length);
                return true;
            }

            cool -= (int)CoreConstant.worldLogicTickMs;
            state = cool;
            return false;
        }
    }
}
