import router from '@ohos.router';
// import '@Demo/BM'
@Entry({routeName:'com.AModule.firstPage'})
@Component
export struct AFirstPage {
  build() {
    Row() {
      Column() {
        Text('A模块的第一个页面')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button("@Entry>B模块的页面1")
          .width('200vp')
          .height('40vp')
          .onClick(()=>{
            router.pushNamedRoute({
              name:'com.BModule.firstpage'
            },router.RouterMode.Standard,(err,data) => {

            })
          })

        Button("@bundle>B模块的页面2")
          .width('200vp')
          .height('40vp')
          .onClick(this.onBModule.bind(this))

        Button("返回")
          .width('200vp')
          .height('40vp')
          .onClick(this.onBack.bind(this))
      }
      .width('100%')
    }
    .height('100%')
  }

  onBack() {
    router.back()
  }

  onBModule() {
    console.log(`>>>>:点转`)
    router.pushUrl({
      url:'@bundle:com.fengsh.myapplication/BModule/ets/pages/BSecondPage'
    },router.RouterMode.Standard,(err,data)=>{
      console.log(`>>>>:${err},${data}`)
    })
  }
}