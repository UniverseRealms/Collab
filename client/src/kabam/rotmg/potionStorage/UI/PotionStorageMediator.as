package kabam.rotmg.potionStorage.UI
{
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

public class PotionStorageMediator extends Mediator
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

    public function PotionStorageMediator()
    {
        super();
    }

    override public function initialize() : void
    {
        this.view.close.add(this.onCancel);
        this.view.ItemButton1.addEventListener(MouseEvent.CLICK,this.onConsume);
        this.view.ItemButton2.addEventListener(MouseEvent.CLICK,this.onConsume2);
        this.view.ItemButton3.addEventListener(MouseEvent.CLICK,this.onConsume3);
        this.view.ItemButton4.addEventListener(MouseEvent.CLICK,this.onConsume4);
        this.view.ItemButton5.addEventListener(MouseEvent.CLICK,this.onConsume5);
        this.view.ItemButton6.addEventListener(MouseEvent.CLICK,this.onConsume6);
        this.view.ItemButton7.addEventListener(MouseEvent.CLICK,this.onConsume7);
        this.view.ItemButton8.addEventListener(MouseEvent.CLICK,this.onConsume8);
        this.view.ItemButton9.addEventListener(MouseEvent.CLICK,this.onConsume9);
        this.view.ItemButton10.addEventListener(MouseEvent.CLICK,this.onConsume10);
        this.view.maxButton1.addEventListener(MouseEvent.CLICK,this.onMax1);
        this.view.maxButton2.addEventListener(MouseEvent.CLICK,this.onMax2);
        this.view.maxButton3.addEventListener(MouseEvent.CLICK,this.onMax3);
        this.view.maxButton4.addEventListener(MouseEvent.CLICK,this.onMax4);
        this.view.maxButton5.addEventListener(MouseEvent.CLICK,this.onMax5);
        this.view.maxButton6.addEventListener(MouseEvent.CLICK,this.onMax6);
        this.view.maxButton7.addEventListener(MouseEvent.CLICK,this.onMax7);
        this.view.maxButton8.addEventListener(MouseEvent.CLICK,this.onMax8);
        this.view.maxButton9.addEventListener(MouseEvent.CLICK,this.onMax9);
        this.view.maxButton10.addEventListener(MouseEvent.CLICK,this.onMax10);
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

    protected function onConsume2(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.DPotions <= 0)
        {
            this.view.player.DPotions = 0;
            return;
        }

        this.view.player.DPotions = (this.view.player.DPotions - 1);
        this.view.Title2.setText("Defense x " + this.player.DPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 2;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume3(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.SPotions <= 0)
        {
            this.view.player.SPotions = 0;
            return;
        }

        this.view.player.SPotions = (this.view.player.SPotions - 1);
        this.view.Title3.setText("Speed x " + this.player.SPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 3;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume4(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.DEPotions <= 0)
        {
            this.view.player.DEPotions = 0;
            return;
        }

        this.view.player.DEPotions = (this.view.player.DEPotions - 1);
        this.view.Title4.setText("Dexterity x " + this.player.DEPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 4;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume5(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.VPotions <= 0)
        {
            this.view.player.VPotions = 0;
            return;
        }

        this.view.player.VPotions = (this.view.player.VPotions - 1);
        this.view.Title5.setText("Vitality x " + this.player.VPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 5;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume6(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.WPotions <= 0)
        {
            this.view.player.WPotions = 0;
            return;
        }

        this.view.player.WPotions = (this.view.player.WPotions - 1);
        this.view.Title6.setText("Wisdom x " + this.player.WPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 6;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume7(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.LPotions <= 0)
        {
            this.view.player.LPotions = 0;
            return;
        }

        this.view.player.LPotions = (this.view.player.LPotions - 1);
        this.view.Title7.setText("Life x " + this.player.LPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 7;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume8(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.MPotions <= 0)
        {
            this.view.player.MPotions = 0;
            return;
        }

        this.view.player.MPotions = (this.view.player.MPotions - 1);
        this.view.Title8.setText("Mana x " + this.player.MPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 8;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume9(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.RPotions <= 0)
        {
            this.view.player.RPotions = 0;
            return;
        }

        this.view.player.RPotions = (this.view.player.RPotions - 1);
        this.view.Title9.setText("Restoration x " + this.player.RPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 9;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onConsume10(me:MouseEvent) : void
    {
        this.player = StaticInjectorContext.getInjector().getInstance(GameModel).player;

        if(this.view.player.LUPotions <= 0)
        {
            this.view.player.LUPotions = 0;
            return;
        }

        this.view.player.LUPotions = (this.view.player.LUPotions - 1);
        this.view.Title10.setText("Luck x " + this.player.LUPotions)
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 10;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax1(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 11;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax2(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 12;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax3(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 13;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax4(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 14;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax5(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 15;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax6(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 16;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax7(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 17;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax8(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 18;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax9(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 19;
        this.socketServer.sendMessage(usepotion);
    }

    protected function onMax10(me:MouseEvent) : void
    {
        var usepotion:UsePotion = null;
        usepotion = this.messages.require(GameServerConnection.USE_POTION) as UsePotion;
        usepotion.itemId_ = 20;
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
