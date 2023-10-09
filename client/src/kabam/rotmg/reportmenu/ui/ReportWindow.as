package kabam.rotmg.reportmenu.ui
{
import com.company.assembleegameclient.account.ui.CheckBoxField;
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.options.ChoiceOption;
import com.company.ui.SimpleText;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.unity.popup.CheckBox;

import kabam.rotmg.chat.control.ShowChatInputSignal;
import kabam.rotmg.core.StaticInjectorContext;

import kabam.rotmg.potionStorage.Items.Item1;
import kabam.rotmg.potionStorage.Items.Item10;
import kabam.rotmg.potionStorage.Items.Item2;
import kabam.rotmg.potionStorage.Items.Item3;
import kabam.rotmg.potionStorage.Items.Item4;
import kabam.rotmg.potionStorage.Items.Item5;
import kabam.rotmg.potionStorage.Items.Item6;
import kabam.rotmg.potionStorage.Items.Item7;
import kabam.rotmg.potionStorage.Items.Item8;
import kabam.rotmg.potionStorage.Items.Item9;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.view.components.DarkLayer;
import kabam.rotmg.util.components.RadioButton;

import org.osflash.signals.Signal;

public class ReportWindow extends Sprite
{

   public var gs_:AGameSprite;

   public var Background:SliceScalingBitmap;
   public var quitButton:SliceScalingButton;
   public var sendButton:SliceScalingButton;

   public var godModeCheck:CheckBox;
   public var killAuraCheck:CheckBox;
   public var otherCheatCheck:CheckBox;

   public var reportText:SimpleText;
   public var playerNameText:SimpleText;
   public var noticeText:SimpleText;
   public var godModeText:SimpleText;
   public var killAuraText:SimpleText;
   public var otherCheatText:SimpleText;

   public var playerName:String;
   public var msg:String;


   public function ReportWindow(playerName:String)
   {
      //Background
      this.playerName = playerName;
      this.msg = " ";
      this.Background = TextureParser.instance.getSliceScalingBitmap("UI", "tab_cointainer_background");
      this.Background.width = 300;
      this.Background.height = 300;
      this.Background.x = 250;
      this.Background.y = 250;


      //All of the checkmarks
      addChild(this.Background);
      this.godModeCheck = new CheckBox("Godmode",false,16,30);
      this.godModeCheck.text_.setTextWidth(300);
      this.godModeCheck.x = 275;
      this.godModeCheck.y = 325;
      addChild(this.godModeCheck);

      this.killAuraCheck = new CheckBox("KillAura",false,16,30);
      this.killAuraCheck.text_.setTextWidth(300);
      this.killAuraCheck.x = 275;
      this.killAuraCheck.y = 375

      addChild(this.killAuraCheck);

      this.otherCheatCheck = new CheckBox("OtherCheat",false,16,30);
      this.otherCheatCheck.text_.setTextWidth(300);
      this.otherCheatCheck.x = 275;
      this.otherCheatCheck.y = 425;
      addChild(this.otherCheatCheck);

      //All the Text thats draw on screen
      this.reportText = new SimpleText(20, 16777215, false, 500, 0, false);
      this.reportText.text = "Report Player";
      this.reportText.setBold(true);
      this.reportText.x = 275;
      this.reportText.y = 275;
      addChild(this.reportText);

      this.playerNameText = new SimpleText(16, 16777215, false, 500, 0, false);
      this.playerNameText.text = "Player Name: " + this.playerName;
      this.playerNameText.x = 275;
      this.playerNameText.y = 300;
      addChild(this.playerNameText);

      this.noticeText = new SimpleText(12,16769280, false,500,0, false);
      this.noticeText.text = "Note: You will be punished if you spam this feature";
      this.noticeText.x = 275;
      this.noticeText.y = 475;
      addChild(this.noticeText);

      this.godModeText = new SimpleText(20, 16777215, false,500,0,false);
      this.godModeText.text = "has God Mode?";
      this.godModeText.x = 325;
      this.godModeText.y = 330;
      addChild(this.godModeText);

      this.killAuraText = new SimpleText(20, 16777215, false,500,0,false);
      this.killAuraText.text = "has Kill Aura?";
      this.killAuraText.x = 325;
      this.killAuraText.y = 380;
      addChild(this.killAuraText);


      this.otherCheatText = new SimpleText(20, 16777215, false,500,0,false);
      this.otherCheatText.text = "has Other Cheats?";
      this.otherCheatText.x = 325;
      this.otherCheatText.y = 430;
      addChild(this.otherCheatText);



      //Quit Button
      this.quitButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
      this.quitButton.addEventListener(MouseEvent.CLICK,this.onClose);
      this.quitButton.x = 500;
      this.quitButton.y = 265;
      addChild(this.quitButton);


      //Send Button
      this.sendButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"))
      this.sendButton.addEventListener(MouseEvent.CLICK, this.onSend);
      this.sendButton.x = 435;
      this.sendButton.width = 92;
      this.sendButton.y = 500;
      this.sendButton.setLabel("Send",DefaultLabelFormat.defaultModalTitle);
      addChild(this.sendButton);
      super();
   }
   private function onSend(e:Event):void{
      if(this.godModeCheck.isChecked())
      {
         this.msg = msg + "Godmode ";
      }
      if(this.killAuraCheck.isChecked())
      {
         this.msg = msg + "Killaura ";
      }
      if(this.otherCheatCheck.isChecked())
      {
         this.msg = msg + "Other Cheats ";
      }
      if(this.msg != " ") {
         //this.gs_.gsc_.playerText("/report " + this.playerName + msg); //This doesn't seem to work?
         var signal:ShowChatInputSignal = StaticInjectorContext.getInjector().getInstance(ShowChatInputSignal);
         signal.dispatch(true, (("/report " + this.playerName) + msg));
      }
      stage.removeChild(this);
   }

   private static function makeLineBuilder(str:String):LineBuilder {
      return (new LineBuilder().setParams(str));
   }

   private function onClose(MouseEvent:Event):void{
      stage.removeChild(this);
   }
}
}