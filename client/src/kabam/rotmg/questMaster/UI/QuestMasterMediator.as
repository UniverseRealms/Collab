package kabam.rotmg.questMaster.UI
{
import kabam.rotmg.potionStorage.UI.*;

import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import flash.events.MouseEvent;
import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.messaging.impl.GameServerConnection;
import kabam.rotmg.messaging.impl.outgoing.UsePotion;

import org.osflash.signals.Signal;

import org.swiftsuspenders.Injector;
import robotlegs.bender.bundles.mvcs.Mediator;

public class QuestMasterMediator extends Mediator
{


    [Inject]
    public var injector:Injector;

    [Inject]
    public var closeDialogs:CloseDialogsSignal;

    [Inject]
    public var socketServer:SocketServer;

    [Inject]
    public var messages:MessageProvider;

    [Inject]
    public var view:PotionStorage;

    [Inject]
    public var openNoModalDialog:OpenDialogNoModalSignal;

    [Inject]
    public var addTextLine:AddTextLineSignal;

    public var player:Player;

    public function QuestMasterMediator()
    {
        super();
    }

    override public function initialize() : void
    {
        this.view.close.add(this.onCancel);
        this.view.ItemButton1.addEventListener(MouseEvent.CLICK,this.onConsume);
    }

    protected function onConsume(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.APotions <= 0)
        {
            this.view.player.APotions = 0;
            return;
        }

        this.view.player.APotions = (this.view.player.APotions - 1);
        this.view.Title1.setText("Attack x " + this.player.APotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 1;
        this.socketServer.sendMessage(usepotion);
    }

    override public function destroy() : void
    {
        this.view.close.remove(this.onCancel);
    }

    private function onCancel() : void
    {
        SoundEffectLibrary.play("button_click");
        this.closeDialogs.dispatch();
    }
}
}
