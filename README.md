# UnifyReturnDemo
返回按钮统一样式的设置
----------
## 实现效果
#### 运行代码前

---

![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_return5.png)

---

#### 运行代码后

---

![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_return1.png)


---

## 代码
#### 使用:拖入工程无需再写任何代码即可实现(需要提供返回图片)
替换系统的backBarButtonItem 实现返回按钮的统一样式
```swift
extension UINavigationItem {
    override open class func initialize() {
        exchange(originMethod: #selector(getter: self.backBarButtonItem), with: #selector(unifiedBackBarButtonItem), classInstance: self)

    }
    
    func unifiedBackBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
}
```
给UINavigationBar添加extension 统一返回按钮图片的样式
```swift
extension UINavigationBarImage {
    override open class func initialize() {
        exchange(originMethod: #selector(getter: self.backIndicatorImage), with: #selector(unifiedBackBar), classInstance: self)
    }
    
    func unifiedBackBarImage() -> UIImage? {
        return adjustImagePosition()!.withRenderingMode(.alwaysOriginal)
    }  
}
```

调整图片的位置
```swift
func adjustImagePosition() -> UIImage?{
    let image = #imageLiteral(resourceName: "return")
    UIGraphicsBeginImageContextWithOptions(CGSize(width: image.size.width+10, height: image.size.height), false, UIScreen.main.scale)
    image.draw(at: CGPoint(x: 10, y: 0))
    
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return finalImage
}
```

交换两个方法的实现
```swift
func exchange(originMethod:Selector,with newMethod:Selector, classInstance: AnyClass) {
    let before : Method  = class_getInstanceMethod(classInstance, originMethod)
    
    let after : Method = class_getInstanceMethod(classInstance, newMethod)
    
    method_exchangeImplementations(before, after)
}
```

## 讲解
在iOS开发中,我们在使用返回按钮的时候,一般都会定义返回按钮的样式于是有了如下的代码
```swift
navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "return").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector
```

```swift
func popToPreviousController() {
    _ = navigationController?.popViewController(animated: true)
}
```
##### 缺点
 1. 每个需要返回的界面都会出现上面的代码
 2. 系统的侧滑返回失效

##### 解决方法
 1. 使用继承,即所有需要返回的界面继承一个父类,在父类中实现如上的代码
 2. 使用如下的代码保留系统的侧滑返回


```swift
 // 遵循 UIGestureRecognizerDelegate 代理方法
 // 代理
func enableGestureReturn() {
 self.navigationController?.interactivePopGestureRecognizer?.delegate = self
}
// 实现代理方法,允许手势,实际测试网上的返回 self.childViewControllers.count > 1 并不可行
func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    //self.childViewControllers.count > 1
    return true
}
```
上面的解决办法会多次的写允许手势的代理方法,进而实际也会用继承来解决.

## 思考
默认的情况下我们不实现任何的代码系统会有默认的返回样式 ,会有类似返回XX界面的按钮,说明即使不写 _ = navigationController?.popViewController(animated: true)  系统仍然知道要返回哪个界面,cmd点击查看 self.navigationItem.leftBarButtonItem后 可以看到如下代码
```swift
open var backBarButtonItem: UIBarButtonItem? // Bar button item to use for the back button in the child navigation item.
```
默认情况下如果我们不实现 leftBarButtonItem也就是说 leftBarButtonItem为nil 的时候使用的是backBarButtonItem,此时我们只需要替换backBarButtonItem方法的实现就可以像系统一样返回,此时想到了运行时runtime,于是我们先写出方法替换的函数

交换新旧方法
```swift
func exchange(originMethod:Selector,with newMethod:Selector, classInstance: AnyClass) {
    let before : Method  = class_getInstanceMethod(classInstance, originMethod)
    
    let after : Method = class_getInstanceMethod(classInstance, newMethod)
    
    method_exchangeImplementations(before, after)
}
```

 1. 交换方法的函数实现了 ,我们还需要找出我们要替换的方法是哪两个,其中一个是实现backBarButtonItem 的方法  一个是我们自定义的方法.
 2. 因为我们要全局的改变返回按钮的样式,而不是针对某一个界面,因此使用extension  UINavigationItem 替换系统的默认样式.
 3. 由于swift中没有+load方法因此使用的是initialize方法.
 4. 此方法类似于对backBarButtonItem的getter方法进行重写.
 5. so 有了如下代码

```swift
extension UINavigationItem {
    override open class func initialize() {
        let before: Method = class_getInstanceMethod(self, #selector(getter: self.backBarButtonItem))
        let after: Method  = class_getInstanceMethod(self, #selector(unifiedBackBarButtonItem))
        
        method_exchangeImplementations(before, after)
    }
    
    func unifiedBackBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
    }
}
```
这样返回按钮设置好了,但是细心的你可能会问为什么没有设置返回的图片,使用如下的代码不好吗?
```swift
func unifiedBackBarButtonItem() -> UIBarButtonItem? {
    return UIBarButtonItem(image: #imageLiteral(resourceName: "return"), style: .plain, target: nil, action: nil)
}
```
此时确实直接设置了返回按钮的图片,但是我们此时的效果是这样的
![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_return3.png)

此时的效果肯定不是我们想要的因此 我们先使用return UIBarButtonItem(title: "", style: .done, target: nil, action: nil),此时设置了title为空,没有设置返回的图片.
接下来我们设置全局的返回图,和最初的思路一样,我们既然改变了UIBarButtonItem 肯定可以改变UIBarButtonItem的返回图片

 1. 使用运行时替换图片的实现方法即self.backIndicatorImage的getter的方法
 2. 由于是全局的替换 因此我们使用extension UINavigationBarImage的方式
```swift
extension UINavigationBarImage {
    override open class func initialize() {
        exchange(originMethod: #selector(getter: self.backIndicatorImage), with: #selector(unifiedBackBar), classInstance: self)
    }
    
    func unifiedBackBarImage() -> UIImage? {
        return adjustImagePosition()!.withRenderingMode(.alwaysOriginal)
    }  
}
```
调整图片的位置
```swift
func adjustImagePosition() -> UIImage?{
    let image = #imageLiteral(resourceName: "return")
    UIGraphicsBeginImageContextWithOptions(CGSize(width: image.size.width+10, height: image.size.height), false, UIScreen.main.scale)
    image.draw(at: CGPoint(x: 10, y: 0))
    
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return finalImage
}
```

为什么要有调整图片位置的代码 , 我们看看未实现调整图片位置代码时的效果,即此时的代码时这样的
```swift
extension UINavigationBar {
    override open class func initialize() {
        exchange(originMethod: #selector(getter: self.backIndicatorImage), with: #selector(unifiedBackBarImage), classInstance: self)
    }
    
    func unifiedBackBarImage() -> UIImage? {
        return #imageLiteral(resourceName: "return").withRenderingMode(.alwaysOriginal)
    }
}
```
![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_return4.png)
此时的图片有些靠左了(当然,如果图片切的好的话可以考虑不使用此方法调整位置,直接返回切好的图就可以了),凡事追求完美,因此我们使用了上面的调整位置的代码实现了最终的效果.

有时候我们需要为某一个界面定义leftBarButtonItem怎么办?
答案: 原来怎么写就怎么写,没有侵入性,不会影响原来的东西
```swift
self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "attention"), style: .plain, target: self, action: #selector(custom))
```
```swift
func custom() {
    print("仍旧可以自定义leftBarButtonItem")
}
```

##总结
最后实现的好处是什么

 1. 无需使用继承
 2. 代码拉入工程即可实现全局返回样式
 3. 仍旧可以自定义leftBarButtonItem
 4. 系统的侧滑返回手势仍旧有效.
 


 欢迎评论,欢迎提出意见,欢迎更好的想法.


