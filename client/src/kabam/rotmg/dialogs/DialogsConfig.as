﻿package kabam.rotmg.dialogs {
import kabam.rotmg.dailyLogin.model.DailyLoginModel;
import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.dialogs.control.PopDialogSignal;
import kabam.rotmg.dialogs.control.PushDialogSignal;
import kabam.rotmg.dialogs.control.ShowDialogBackgroundSignal;
import kabam.rotmg.dialogs.view.DialogsMediator;
import kabam.rotmg.dialogs.view.DialogsView;

import org.swiftsuspenders.Injector;

import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;

public class DialogsConfig implements IConfig {

    [Inject]
    public var injector:Injector;
    [Inject]
    public var mediatorMap:IMediatorMap;


    public function configure():void {
        this.injector.map(ShowDialogBackgroundSignal).asSingleton();
        this.injector.map(OpenDialogSignal).asSingleton();
        this.injector.map(OpenDialogNoModalSignal).asSingleton();
        this.injector.map(CloseDialogsSignal).asSingleton();
        this.injector.map(FlushPopupStartupQueueSignal).asSingleton();
        this.injector.map(AddPopupToStartupQueueSignal).asSingleton();
        this.injector.map(DailyLoginModel).asSingleton();
        this.injector.map(PushDialogSignal).asSingleton();
        this.injector.map(PopDialogSignal).asSingleton();
        this.mediatorMap.map(DialogsView).toMediator(DialogsMediator);
    }


}
}
