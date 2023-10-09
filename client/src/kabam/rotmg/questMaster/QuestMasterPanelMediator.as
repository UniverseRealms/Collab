package kabam.rotmg.questMaster
{
import com.company.assembleegameclient.game.AGameSprite;
import flash.events.MouseEvent;
import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
import kabam.rotmg.questMaster.UI.QuestMaster;

import robotlegs.bender.bundles.mvcs.Mediator;

public class QuestMasterPanelMediator extends Mediator
{


   [Inject]
   public var view:QuestMasterPanel

   [Inject]
   public var openDialog:OpenDialogNoModalSignal;

   [Inject]
   public var gameSprite:AGameSprite;

   public function QuestMasterPanelMediator()
   {
      super();
   }

   override public function initialize() : void
   {
      this.view.button.addEventListener(MouseEvent.CLICK,this.onButtonLeftClick);
   }

   private function onButtonLeftClick(_arg1:MouseEvent) : void
   {
      this.openDialog.dispatch(new QuestMaster(this.gameSprite));
   }

   override public function destroy() : void
   {
      super.destroy();
   }
}
}
