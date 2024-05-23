import router from '@ohos.router';
import "@Demo/AM"
import common from '@ohos.app.ability.common';
import { Want } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State message: string = 'RouterDemo';
  private context = getContext(this) as common.UIAbilityContext;
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button("同模块")
          .width('200vp')
          .height('40vp')
          .onClick(this.onInSameModule.bind(this))

        Button("A模块页面")
          .width('200vp')
          .height('40vp')
          .onClick(this.onOpenAModule.bind(this))

        Button("动态共享库Library")
          .width('200vp')
          .height('40vp')
          .onClick((event)=>{
            // @bundle:com.my.application/动态库名称/ets/pages/页面名称
            // 需要在动态库模块的main_pages.json里设置路由
            router.pushUrl({ url: '@bundle:com.fengsh.myapplication/Testlibrary/ets/pages/Index'},(err)=>{
              console.log(`>>>>: ${err}`)
            })
          })

        Button("Feature Ability")
          .width('200vp')
          .height('40vp')
          .onClick((event)=>{
            console.log(">>>>:RRRRRR")
            let want: Want = {
              deviceId: '',
              bundleName: 'com.fengsh.myapplication',
              moduleName: 'FAbility',
              abilityName: 'FAbilityAbility'
            }
            this.context.startAbility(want,(err)=>{
              console.log('Tag', 'error.code = ' + err.code)
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  //同模块路由跳转
  onInSameModule(event: ClickEvent) {
    router.pushUrl({
      url:'pages/SecondPage'
    },router.RouterMode.Standard,(err,data) => {

    })
  }

  onOpenAModule(event: ClickEvent) {
    router.pushNamedRoute({
      name:'com.AModule.firstPage'
    },router.RouterMode.Standard,(err,data) => {

    })
  }
}