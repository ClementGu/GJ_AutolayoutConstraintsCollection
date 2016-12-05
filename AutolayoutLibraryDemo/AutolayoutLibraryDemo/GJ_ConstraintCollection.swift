//
//  QK_ConstraintCollection.swift
//  captchaDemo
//
//  Created by Clement_Gu on 2016/11/8.
//  Copyright © 2016年 clement. All rights reserved.
//

/**
   1. 这是一个约束代码pool 将所有约束归类到这里 虽然没有messory强大 也没有snapKit牛逼
 但是贵在积累 可以减少代码的重复使用率
 
   2. 因为swift 的版本比较不稳地 更新迭代语法修改比较大 这样每次版本发布对于用swift开发的人来说是灾难性的大量代码修改还不一定能搞定
   3. 所以针对这一个现象，我觉得减少代码的数量增加复用性是很好的解决办法，这里我将纯代码模式下的约束都归为一类公用池，当每次版本更新的时候只要修改Pool中的少量代码就可以了。
   4. 当然有人要问，那怎么不用第三方的呢，第三方的功能强大效率高框架也好。
   5. 个人觉得第三方是牛，但是一味地依赖别人的作品那么作为程序员的乐趣和骄傲又在哪里，同时第三方在版本更替的时候也需要修改对别人的依赖性太大，自己为自己量身定制一套公用池以来可以大大提高开发效率，同时这个公用池会随着自己的技术提高不断完善，在版本更替的时候可以第一时间修改公用池以适应项目这样依赖性大大降低。等你技术够牛，你就是第三方框架的制造者。
    6.预计还有 attributedPool  functionPool  customViewPool ModelPool oneKeyAssignModelPool customControlsPool 的制作相信随着公共池的制作完成，代码流的开发效率不会比xib或者storyBoard差 低耦合高内聚性能却能更好的展现。
 
 
 */

import UIKit

class GJ_ConstraintCollection: NSObject {
    
    /**
     执行约束的方法
     
     - parameter constraints: 添加的约束数组
     - parameter baseView:    所有添加约束的最大父view
     */
    func activeConstraints(constraints:[NSLayoutConstraint],baseView:UIView)
    {
        if #available(iOS 8.0, *) {
            //8.0后用的方法
            NSLayoutConstraint.activateConstraints(constraints)
        } else {
            //8.0之前6.0之后用这个方法 baseview为最大的主view
            baseView.addConstraints(constraints)
        }
        
    }
    
    /**
     获取有效约束数组后并执行约束
     
     - parameter originalCons: 方法中原始设定的约束数组
     - parameter definedValue: 设定的约束失效数据即当约束值constant为1.20的时候这个约束失效 当然修改definedValue可以修改这个约定值
     - parameter addConsView:  8.0版本之前约束添加的总父视图
     注：这边使用了一个通用的约束，然后商定一个特定的值使不想使用的约束失效 再来筛选出想使用的约束来实现约束特别化 的思路 失效值为 1.20
     */
    func getEffectiveConstraints(originalCons:[NSLayoutConstraint],definedValue:CGFloat,addConsView:UIView)
    {
        //然后创建可变数组 来储存筛选出来的约束
        var constraint = [NSLayoutConstraint]()
        //这边数组的先后顺序不影响结果 所以这边不用考虑顺序问题
        for item in originalCons
        {
            //判断我们约定好的不执行的值
            if item.constant == definedValue
            {
                //不执行操作
            }
            else
            {
                //将筛选出来的约束放进新的约束数组
                constraint.append(item)
            }
            
        }
        //最后执行最终筛选出来的约束 好吧 就这样结束了  所以我们可以再把这个方法再封装成一个新的方法 毕竟写重复的代码实在是不能忍受的一件事
        activeConstraints(constraint, baseView: addConsView)

        
    }
    
    
    /**
     创建一个控件的宽和高
     
     - parameter baseView: 控件
     - parameter Width:    宽
     - parameter height:   高
     注：这边是这么设计的 当宽或者高一个值为0的时候 那么默认不执行这个约束 即只设定单个约束
     */
    func gj_SetWidthAndHeight(baseView:UIView,Width:CGFloat,height:CGFloat)
    {
        //最主要的是view 要把autorizing设置成false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //宽
        let viewWidth = NSLayoutConstraint.init(item: baseView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Width)
        //高
        let viewHeight = NSLayoutConstraint.init(item: baseView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        //执行约束
        if Width == 1.20
        {
            //执行高的约束
            activeConstraints([viewHeight], baseView: baseView)
        }
        else if height == 1.20
        {
            //执行宽的约束
            activeConstraints([viewWidth], baseView: baseView)
        }
        else
        {
            //执行两个约束
            activeConstraints([viewWidth,viewHeight], baseView: baseView)
        }
   
    }
    
    /**
     创建子view在父视图的位置
     
     - parameter baseView:  子视图
     - parameter reference: 父视图
     - parameter leftDis:   距离父视图左边的距离
     - parameter topDis:    距离父视图顶部的距离
     - parameter rightDis:  距离父视图右边的距离
     - parameter bottomDis: 距离父视图底部的距离
     注:这边的设计思路是 子视图与父视图的关系 但是有的时候不一定要四个约束 所以在遇到约束不需要使用的时候那么 这个约束给一个特定的值不为0（因为与父视图的距离可以是0） 所以这边定义 1.20 为不执行操作的约束 别问为什么 肯定有意义
     */
    func gj_SetSubSquareDistance(baseView:UIView,reference:UIView,leftDis:CGFloat,topDis:CGFloat,rightDis:CGFloat,bottomDis:CGFloat)
    {
        //先取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //然后设置四边的约束
        let left = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .Equal, toItem: reference, attribute: .Leading, multiplier: 1, constant: leftDis)
        let right = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .Equal, toItem: reference, attribute: .Trailing, multiplier: 1, constant: rightDis)
        let top = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .Equal, toItem: reference, attribute: .Top, multiplier: 1, constant: topDis)
        let bottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .Equal, toItem: reference, attribute: .Bottom, multiplier: 1, constant: bottomDis)
        //再组成数组
        let cons = [left,right,top,bottom]
       //然后调用封装的方法
        getEffectiveConstraints(cons, definedValue: 1.20, addConsView: reference)
    }
    
    func gj_SetEqualSquareDistance(baseView:UIView,reference:UIView,leftDis:CGFloat,topDis:CGFloat,rightDis:CGFloat,bottomDis:CGFloat)
    {
        //先取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //然后设置四边的约束
        let left = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .Equal, toItem: reference, attribute: .Trailing, multiplier: 1, constant: leftDis)
        let right = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .Equal, toItem: reference, attribute: .Leading, multiplier: 1, constant: rightDis)
        let top = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .Equal, toItem: reference, attribute: .Bottom, multiplier: 1, constant: topDis)
        let bottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .Equal, toItem: reference, attribute: .Top, multiplier: 1, constant: bottomDis)
        //再组成数组
        let cons = [left,right,top,bottom]
        //然后调用封装的方法 这边约束添加在自己身上
        getEffectiveConstraints(cons, definedValue: 1.20, addConsView: baseView)
 
    }
    
    /**
     设置view的centerX和CenterY
     
     - parameter baseView:  设置的视图
     - parameter reference: 参照的视图
     - parameter xDis:      距离参照视图CenterX的距离
     - parameter yDis:      距离参照视图CenterY的距离
     注：这边用的原理是定义centerX和centerY 然后用1.20 让不想用的约束失效 然后执行有效是的约束
     */
    func gj_SetCenterXAndY(baseView:UIView,reference:UIView,xDis:CGFloat,yDis:CGFloat)
    {
        //先取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //然后设置约束
        let centerX = NSLayoutConstraint.init(item: baseView, attribute: .CenterX, relatedBy: .Equal, toItem: reference, attribute: .CenterX, multiplier: 1, constant: xDis)
        let centerY = NSLayoutConstraint.init(item: baseView, attribute: .CenterY, relatedBy: .Equal, toItem: reference, attribute: .CenterY, multiplier: 1, constant: yDis)
        //获取有效约束
        getEffectiveConstraints([centerX,centerY], definedValue: 1.20, addConsView: baseView)

    }
    /**
     创建类似表格cell的view排列约束
     
     - parameter baseView: 目标视图
     - parameter refMain:  左右约束父视图参照视图
     - parameter refEqual: 顶部约束的同级视图
     - parameter leftDis:  左边距离
     - parameter topDis:   顶部距离
     - parameter rightDis: 右边距离
     - parameter height:   目标视图的高度
     注：这边本来考虑设计添加顶部cell的约束和底部cell的约束功能 但是觉得太浪费内存 而且之前subSquare和euqalSquare中可以将不同的约束部分补充 所以在这个方法就不集成了
     现在默认如果refmain 和 refEqual相等 则说明cellview是顶部view 分情况讨论下 这样简单的解决了一下问题
     */
    func gj_StyleForCellView(baseView:UIView,refMain:UIView,refEqual:UIView,leftDis:CGFloat,topDis:CGFloat,rightDis:CGFloat,height:CGFloat)
    {
        //1.取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //2.创建所有约束 这边top属性对应的是同级的view
        let left = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .Equal, toItem: refMain, attribute: .Leading, multiplier: 1, constant: leftDis)
        var top = NSLayoutConstraint()
        //如果两个参照view相等为主view
        if refMain == refEqual
        {
            top = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .Equal, toItem: refEqual, attribute: .Top, multiplier: 1, constant: topDis)
        }
        else
        {
            top = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .Equal, toItem: refEqual, attribute: .Bottom, multiplier: 1, constant: topDis)
        }
        let right = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .Equal, toItem: refMain, attribute: .Trailing, multiplier: 1, constant: rightDis)
        let height = NSLayoutConstraint.init(item: baseView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        //3.获取有效约束
        getEffectiveConstraints([left,top,right,height], definedValue: 1.20, addConsView: refMain)
        
    }
    /**
     创建类似表格的Cell复用排列约束 以底部为参照
     
     - parameter baseView:  目标视图
     - parameter refMain:   参照父视图
     - parameter refEqual:  参照同级视图
     - parameter leftDis:   左边距离
     - parameter rightDis:  右边距离
     - parameter bottomDis: 底部跟 父视图/子视图 的距离
     - parameter height:    单元格的高度
     注：这边是通过对比两个参照视图来决定底部约束的写法的，跟上面写法一直就是排列方向是从下往上而已
     
     */
    func gj_StyleForBottomCellView(baseView:UIView,refMain:UIView,refEqual:UIView,leftDis:CGFloat,rightDis:CGFloat,bottomDis:CGFloat,height:CGFloat)
    {
        //1.取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //2.创建所有约束 这边top属性对应的是同级的view
        let left = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .Equal, toItem: refMain, attribute: .Leading, multiplier: 1, constant: leftDis)
        let right = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .Equal, toItem: refMain, attribute: .Trailing, multiplier: 1, constant: rightDis)
        var bottom = NSLayoutConstraint()
        //如果两个参照view相等为主view
        if refMain == refEqual
        {
            bottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .Equal, toItem: refEqual, attribute: .Bottom, multiplier: 1, constant: bottomDis)
        }
        else
        {
            bottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .Equal, toItem: refEqual, attribute: .Top, multiplier: 1, constant: bottomDis)
        }
        let height = NSLayoutConstraint.init(item: baseView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        //3.获取有效约束
        getEffectiveConstraints([left,right,bottom,height], definedValue: 1.20, addConsView: refMain)
     
    }
    
    /**
     设置子view相对于父view四边的距离>= 或者 <=
     
     - parameter baseView:  设置view
     - parameter reference: 参照父view
     - parameter isLess:    是否是<=
     - parameter leftDis:   左边距离
     - parameter topDis:    顶部距离
     - parameter rightDis:  右边距离
     - parameter bottomDis: 底部距离
     注：这边的原理是通过isless的true和false来判断是>=还是<= 然后匹配想要设置的四边距离，不用设置用默认值1.20来使其失效
     */
    func gj_SetSubLessOrGreaterThan(baseView:UIView,reference:UIView,isLess:Bool,leftDis:CGFloat,topDis:CGFloat,rightDis:CGFloat,bottomDis:CGFloat)
    {
        //1.取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //2.创建所有约束 
        if isLess == true
        {
            //2.1<= 的约束
            let lessLeft = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Leading, multiplier: 1, constant: leftDis)
            let lessTop = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Top, multiplier: 1, constant: topDis)
            let lessRight = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Trailing, multiplier: 1, constant: rightDis)
            let lessBottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Bottom, multiplier: 1, constant: bottomDis)
            //3.1筛选执行约束
            getEffectiveConstraints([lessLeft,lessTop,lessRight,lessBottom], definedValue: 1.20, addConsView: baseView)
        }
        else
        {
            //2.2>=的约束
            let greaterLeft = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Leading, multiplier: 1, constant: leftDis)
            let greaterTop = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Top, multiplier: 1, constant: topDis)
            let greaterRight = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Trailing, multiplier: 1, constant: rightDis)
            let greaterBottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Bottom, multiplier: 1, constant: bottomDis)
            //3.2筛选执行约束
            getEffectiveConstraints([greaterLeft,greaterTop,greaterRight,greaterBottom], definedValue: 1.20, addConsView: baseView)
        }
    }
    
    /**
     设置平行view之间的>=和<=关系和距离
     
     - parameter baseView:  目标view
     - parameter reference: 参照平行view
     - parameter isLess:    是否是<=
     - parameter leftDis:   左边距离
     - parameter topDis:    顶部距离
     - parameter rightDis:  右边距离
     - parameter bottomDis: 底部距离
     注：这边的原理跟上面父子视图一样就是方向变了，isLess 为真 则是<= 否则 >= 然后想要设置的为想要设置的距离 不想设置的用1.20 使其失效
     */
    func gj_SetEqualLessOrGreaterThan(baseView:UIView,reference:UIView,isLess:Bool,leftDis:CGFloat,topDis:CGFloat,rightDis:CGFloat,bottomDis:CGFloat)
    {
        //1.取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //2.创建所有约束
        if isLess == true
        {
            //2.1<= 的约束
            let lessLeft = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Trailing, multiplier: 1, constant: leftDis)
            let lessTop = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Bottom, multiplier: 1, constant: topDis)
            let lessRight = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Leading, multiplier: 1, constant: rightDis)
            let lessBottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: reference, attribute: .Top, multiplier: 1, constant: bottomDis)
            //3.1筛选执行约束
            getEffectiveConstraints([lessLeft,lessTop,lessRight,lessBottom], definedValue: 1.20, addConsView: baseView)
        }
        else
        {
            //2.2>=的约束
            let greaterLeft = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Trailing, multiplier: 1, constant: leftDis)
            let greaterTop = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Bottom, multiplier: 1, constant: topDis)
            let greaterRight = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Leading, multiplier: 1, constant: rightDis)
            let greaterBottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: reference, attribute: .Top, multiplier: 1, constant: bottomDis)
            //3.2筛选执行约束
            getEffectiveConstraints([greaterLeft,greaterTop,greaterRight,greaterBottom], definedValue: 1.20, addConsView: baseView)
        }
    }
    
    /**
     设置同级视图的长宽上下左右边距的距离
     
     - parameter baseView:  设置View
     - parameter reference: 参照View
     - parameter widthEq:   宽度与参照View的宽度差
     - parameter heightEq:  高度与参照view的高度差
     - parameter leftEq:    左边与参照view左边的距离
     - parameter topEq:     顶部与参照View顶部的距离
     - parameter rightEq:   右边与参照View右边的距离
     - parameter bottomEq:  底部与参照View底部的距离
     注：这边原理是 两个平级的view 在一定程度上平行 然后通过参照View的左右上下的位置以及宽高来设置目标View的想设置的属性，这边将不需要设置的属性用1.20传值就可以了
     */
    func gj_SetSixEqualForTwoEqualView(baseView:UIView,reference:UIView,widthEq:CGFloat,heightEq:CGFloat,leftEq:CGFloat,topEq:CGFloat,rightEq:CGFloat,bottomEq:CGFloat)
    {
        //1.取消autorizing
        baseView.translatesAutoresizingMaskIntoConstraints = false
        //2.创建所有约束
        let width = NSLayoutConstraint.init(item: baseView, attribute: .Width, relatedBy: .Equal, toItem: reference, attribute: .Width, multiplier: 1, constant: widthEq)
        let height = NSLayoutConstraint.init(item: baseView, attribute: .Height, relatedBy: .Equal, toItem: reference, attribute: .Height, multiplier: 1, constant: heightEq)
        let left = NSLayoutConstraint.init(item: baseView, attribute: .Leading, relatedBy: .Equal, toItem: reference, attribute: .Leading, multiplier: 1, constant: leftEq)
        let top = NSLayoutConstraint.init(item: baseView, attribute: .Top, relatedBy: .Equal, toItem: reference, attribute: .Top, multiplier: 1, constant: topEq)
        let right = NSLayoutConstraint.init(item: baseView, attribute: .Trailing, relatedBy: .Equal, toItem: reference, attribute: .Trailing, multiplier: 1, constant: rightEq)
        let bottom = NSLayoutConstraint.init(item: baseView, attribute: .Bottom, relatedBy: .Equal, toItem: reference, attribute: .Bottom, multiplier: 1, constant: bottomEq)
        //3.筛选有效约束
        getEffectiveConstraints([width,height,left,top,right,bottom], definedValue: 1.20, addConsView: baseView)
 
    }
    
    
    
    
    
    
    
    
}
