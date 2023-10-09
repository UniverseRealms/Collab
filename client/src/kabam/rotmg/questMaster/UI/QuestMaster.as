package kabam.rotmg.questMaster.UI
{
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.gird.UIGrid;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.tabs.UITab;
import io.decagames.rotmg.ui.tabs.UITabs;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class QuestMaster extends Sprite
{
   private var gs_:AGameSprite;
   private var Image:Bitmap;
   public var quitButton:SliceScalingButton;
   public const close:Signal = new Signal();

   private var backgroundAll:SliceScalingBitmap;
   private var nameTextBackground:SliceScalingBitmap;
   public var Title:TextFieldDisplayConcrete;
   public var Box:SliceScalingBitmap;

   private var tabs:UITabs;
   private var infoGrid:UIGrid;
   private var questsGrid:UIGrid;

   public function QuestMaster(arg1:AGameSprite)
   {
      this.gs_ = arg1;
      var NPC:BitmapData = null;
      this.backgroundAll = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header", 600);
      this.backgroundAll.y = 0;
      addChild(this.backgroundAll);
      this.nameTextBackground = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header_title", 400);
      this.nameTextBackground.y = this.backgroundAll.y + 26;
      this.nameTextBackground.x = 105;
      addChild(this.nameTextBackground);
      this.Title = new TextFieldDisplayConcrete().setSize(30).setColor(0xFFFFFF).setBold(true);
      this.Title.setAutoSize(TextFieldAutoSize.CENTER);
      this.Title.setBold(true);
      this.Title.setStringBuilder(new LineBuilder().setParams("Quest Master"));
      this.Title.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
      this.Title.x = nameTextBackground.x + 200;
      this.Title.y = nameTextBackground.y + 20;
      addChild(this.Title);

      this.quitButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
      this.quitButton.addEventListener(MouseEvent.CLICK,this.onClose);
      this.quitButton.x = 417;
      this.quitButton.y = 45;
      addChild(this.quitButton);

      NPC = AssetLibrary.getImageFromSet("lofiCharBig",370);
      NPC = TextureRedrawer.redraw(NPC, 50, true, 0);
      this.Image = new Bitmap(NPC);

      this.tabs = new UITabs(590);
      this.tabs.addTab(this.createInfoTab());
      this.tabs.addTab(this.createQuestsTab());
      this.tabs.y = 115;
      this.tabs.x = 3;
      this.addChild(this.tabs);
   }

   private function infoTab() {
      this.Image.scaleX = 5;
      this.Image.scaleY = 5;
      this.Image.x = 10;
      this.Image.y = 135;
      addChild(this.Image);
   }

   private function questsTab() {
   }

   private function createInfoTab() : UITab
   {
      var _loc1_:UITab = new UITab("Info",true);
      this.infoGrid = new UIGrid(550,2,6,384,3,_loc1_);
      this.infoGrid.x = 10;
      this.infoGrid.decorBitmap = "tabs_tile_decor";
      _loc1_.addContent(this.infoGrid);
      return _loc1_;
   }

   private function createQuestsTab() : UITab
   {
      var _loc1_:UITab = new UITab("Quests",true);
      this.questsGrid = new UIGrid(550,2,6,384,3,_loc1_);
      this.questsGrid.x = 10;
      this.questsGrid.decorBitmap = "tabs_tile_decor";
      _loc1_.addContent(this.questsGrid);
      return _loc1_;
   }


   private function onClose(param1:Event) : void
   {
      this.close.dispatch();
   }
}
}