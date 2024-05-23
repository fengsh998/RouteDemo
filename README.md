IDE：4.1.3.500版本，API：11
### 一、同模块中的页面跳转路由
新建工程，默认只有entry模块，在pages目录下建一个SecondPage.ets文件
[图片]
配置路由表，即在resources->base->profile->main_pages.json中
```json
{
"src": [
"pages/Index",
"pages/SecondPage" //添加要跳转的路由
]
}
```

Index.ets
```javascript
import router from '@ohos.router';

@Entry
@Component
struct Index {
@State message: string = 'RouterDemo';
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
}
```

SecondPage.ets
```javascript
import router from '@ohos.router';
@Entry
@Component
struct SecondPage {
build() {
Row() {
Column() {
Text("SecondPage")
.fontSize(50)
.fontWeight(FontWeight.Bold)

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
}
```

总结：关键点在于必须要在main_pages.json中定义路对应的路由

### 二、多Har或Hsp共享库模块中的路由跳转

#### 1、使用@Entry({routeName:'xxxx'})的方式
新增两个ShareLibrary/StaticLibrary 的 模块AModule,BModule。
[图片]
entry调用A模块的页面：
步聚：
1、A 模块中需要被调用的页面，设置路由名，eg:@Entry({routeName:'com.AModule.firstPage'})
AFirstPage.ets
```javascript
import router from '@ohos.router';

///步聚一：路由关键设置
@Entry({routeName:'com.AModule.firstPage'})
@Component
export struct AFirstPage { //需要用export 导出
    build() {
        Row() {
            Column() {
                Text('A模块的第一个页面')
                    .fontSize(50)
                    .fontWeight(FontWeight.Bold)
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
}
```

2、在A模块的统一导出文件Index.ets中导出模块
//步聚二：导出
```text
export { AFirstPage } from './src/main/ets/pages/AFirstPage'
```

[图片]
3、可单模块引入，也可以全局引入A模块，这里使用的是工程全局引用，在工程的oh-package.json5中添加
"@Demo/AM": "file:../RouterDemo/AModule"  //步聚三
[图片]
4、在调用的页引入A块模导出的页。eg：例子中entry->调用A模块的页面，则在entry的Index页面引入
import "@Demo/AM" //步聚四
[图片]
entry->Index.ets
```javascript
import router from '@ohos.router';
import "@Demo/AM" //关键点，必须导入A模块，且确定A模块导出了可打开路由的页面
@Entry
@Component
struct Index {
@State message: string = 'RouterDemo';
build() {
Row() {
Column() {
Text(this.message)
.fontSize(50)
.fontWeight(FontWeight.Bold)

        Button("A模块页面")
          .width('200vp')
          .height('40vp')
          .onClick(this.onOpenAModule.bind(this))
      }
      .width('100%')
    }
    .height('100%')
}

onOpenAModule(event: ClickEvent) {
router.pushNamedRoute({
name:'com.AModule.firstPage' //A模块中@Entry设置的路由名
},router.RouterMode.Standard,(err,data) => {

    })
}
}
```


总结关键点：
a、声明可外部或其它模块调用的路由名，使用@Entry({routeName:'路由名'})。
b、使用export 把该页面导出，可供外部使用。
c、调用者(如：entry)必须导入依赖（如A模块）
d、使用router.pushNamedRoute的API进行调用

优缺点：
优：
a、不需要在main_pages.json中定义路由。
b、不需要知道模块页面所在包中的具体路径位置。
c、不需要在entry模块的设置里deploy multi hap中勾选相关的依赖。
缺：
在调用处都需要导入对应的模块依赖，如果没有统一的依赖管理，可能会形成依赖循环，从而导致编译失败。
可使用全局一次性导入所有模块的方式来破局，不再在调用者处单独导入。

#### 2、使用@bundle:应用包名+模块对应的路径
参数是@bundle:com.my.application/动态库名称/ets/pages/页面名称
可参考：https://juejin.cn/post/7327094228349567026
步聚一：包名的获取：AppScope->resources->app.json5文件里的bundleName
[图片]
步聚二：
把要暴露的路由在模块中的main_pages.json中设置如图
[图片]
步聚三：由于这里建的是ShareLibrary所以在工程的配置页的entry里把依赖勾上。deploy Multi Hap里
[图片]
步聚四：调用router.pushUrl({ url: '@bundle:com.fengsh.myapplication/Testlibrary/ets/pages/Index'})
```javascript
import router from '@ohos.router';

@Entry
@Component
struct Index {
@State message: string = 'RouterDemo';
build() {
Row() {
Column() {
Text(this.message)
.fontSize(50)
.fontWeight(FontWeight.Bold)


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

        
      }
      .width('100%')
    }
    .height('100%')
}
}
```

总结优缺点：
优点：
不需要export 具体的页面，也不需要指定路由名。
没有特环依赖冲突问题。
缺点：
路径是死的且路径只能是ets/pages/，必须对应按包路径指定，对外提供动态路由时灵活度不高。
此方式不支持HAR模块即（StaticLibrary）

#### 3、使用Want调用Feature Ability模块中的UI页面
Want的使用：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/want-overview-0000001478340877-V2
新建一个EmptyAbility 即（feature类型的）
[图片]
[图片]
步聚一：
在Ability模块中的main_pages.json中设置路由
步聚二：
在entry的工程配置中把依赖勾上。
[图片]
步聚三：使用want调用。
entry->Index.ets
```javascript
import router from '@ohos.router';
///引入ability Want
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

        Button("Feature Ability")
          .width('200vp')
          .height('40vp')
          .onClick((event)=>{
            //使用Want 进行跳转
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

}
```



4、（有可能出现）解决循环引用编译冲突问题：针对@Entry() 设置路由名的方式
entry模块为entry类型，A模块，B模块分别为Share类型
暂时无法在飞书文档外展示此内容
例子演示 Entry ->push 一个A模块的页面，A模块里可以push一个B模块的页面，同时B模块也可以push一个A模块的页面（故意形成AB模块相互依赖），B模块同样可以push一个Entry模块中页面，从成形成一个大环。
实际项目中不一定是环状调用，这里用环状主要是考虑到过程中相互依赖时可能产生循环引用导致编译失败的问题解决方式。
其它模块调用entry中的页面不需要导入模块，只需要页面export导出，并且使用过该面(没使用过的好像调不了)。
所以entry模块通常只用来做壳子工程，具体的业务模块都放在其它模块。

AModule的页面引入B模块 import '@Demo/BM'
BModule的页面引入A模块 import '@Demo/AM'
[图片]
破解循环引用。
新建一个Sharelibrary,取个好听点的名，如：PublicModulessk
[图片]
只保留Index.ets文件
```text
import * as A from '@Demo/AM'
import * as B from '@Demo/BM'

export {
A,B
}
```

在全局的oh-package.json5 中引入依赖
[图片]
```json
{
"name": "routerdemo",
"version": "1.0.0",
"description": "Please describe the basic information.",
"main": "",
"author": "",
"license": "",
"dependencies": {
},
"devDependencies": {
...
"@Demo/AM": "file:../RouterDemo/AModule",
"@Demo/BM": "file:../RouterDemo/BModule",
"@Demo/PM": "file:../RouterDemo/PublicModules"
}
}
```
然后在ability的模块中进行一次全局导入import '@Demo/PM'
[图片]