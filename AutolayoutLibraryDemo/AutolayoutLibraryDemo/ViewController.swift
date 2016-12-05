//
//  ViewController.swift
//  AutolayoutLibraryDemo
//
//  Created by Clement_Gu on 2016/12/2.
//  Copyright © 2016年 clement. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    /// 约束集合实例化
    private lazy var layout:GJ_ConstraintCollection = GJ_ConstraintCollection()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //构建界面
        buildAllControlsAndConstraints()
    }
    //创建界面
    func buildAllControlsAndConstraints()
    {
        //这边主要是展示下约束的用法
        //1.创建一个view
        let mainView = UIView()
        mainView.backgroundColor = UIColor.orangeColor()
        view.addSubview(mainView)
        //创建约束
        //1.用实例化的约束集合布局
        //注：这个是子View相对于父view的边距 左上 为正 右下 为负  baseView是子视图 reference 为父视图 不需要设置的属性用1.20代替 1.20是默认的失效数值
        layout.gj_SetSubSquareDistance(mainView, reference: view, leftDis: 15, topDis: 79, rightDis: -15, bottomDis: 1.20)
        //注：这个是设置view的宽高 不需要设置的用 1.20 代替
        layout.gj_SetWidthAndHeight(mainView, Width: 1.20, height: 300)
        
        //2.设置平行view
        let secView = UIView()
        secView.backgroundColor = UIColor.grayColor()
        view.addSubview(secView)
        //2.约束
        //注:这边是设置平级view的约束 默认 左边 对应 参照view的右边 上边对应下边  右边对应左边 下边对应上边 1.20为不设置
        //设置顶部距离
        layout.gj_SetEqualSquareDistance(secView, reference: mainView, leftDis: 1.20, topDis: 20, rightDis: 1.20, bottomDis: 1.20)
        //设置与父view的距离
        layout.gj_SetSubSquareDistance(secView, reference: view, leftDis: 15, topDis: 1.20, rightDis: -15, bottomDis: -18)
        
        //3.设置cell类型的view
        //注：因为跟tableviewcell 一样的表格出现的概率很多所以做了一个专门的方法
        //先创建几个view
        let cellViewOne = UIView()
        cellViewOne.backgroundColor = UIColor.blueColor()
        let cellViewTwo = UIView()
        cellViewTwo.backgroundColor = UIColor.brownColor()
        let cellViewThree = UIView()
        cellViewThree.backgroundColor = UIColor.blackColor()
        let cellViewFour = UIView()
        cellViewFour.backgroundColor = UIColor.darkGrayColor()
        //重复的代码不能忍 所以就封装起来
        viewAddSubViews(mainView, subViewArr: [cellViewOne,cellViewTwo,cellViewThree,cellViewFour])
        //约束 适用情况 左右两边是父view 上边是父view（第一个cell）或者其他cell（中间的view）
        //1.正向cell排列
        //1.1 refMain 是父view refEqual为平级view  当refMain 和 refEuqal 是同一个view （都为父View 不可以是子View）那么 topDis 默认为与父View的top的距离
        layout.gj_StyleForCellView(cellViewOne, refMain: mainView, refEqual: mainView, leftDis: 10, topDis: 10, rightDis: -10, height: 40)
        //1.2 如果 refMain 和 refEqual 是不同的 即refMain 是 父view refEqual 是平级的View 那么topDis 就是距离平级的顶部距离
        layout.gj_StyleForCellView(cellViewTwo, refMain: mainView, refEqual: cellViewOne, leftDis: 10, topDis: 10, rightDis: -10, height: 40)
        layout.gj_StyleForCellView(cellViewThree, refMain: mainView, refEqual: cellViewTwo, leftDis: 10, topDis: 10, rightDis: -10, height: 40)
        //2.反向排列
        // 这边和正向排列一样 只是方向反过来了
        layout.gj_StyleForBottomCellView(cellViewFour, refMain: mainView, refEqual: mainView, leftDis: 10, rightDis: -10, bottomDis: -10, height: 40)
    
        //4.创建类似的view 平行的view
        let leftBtn = UIButton()
        leftBtn.backgroundColor = UIColor.yellowColor()
        let rightBtn = UIButton()
        rightBtn.backgroundColor = UIColor.cyanColor()
        viewAddSubViews(view, subViewArr: [leftBtn,rightBtn])
        //约束
        //先正常设置左边的view
        //设置左边上边的额距离
        layout.gj_SetSubSquareDistance(leftBtn, reference: mainView, leftDis: 10, topDis: 170, rightDis: 1.20, bottomDis: 1.20)
        //右边与rightBtn的左边相等
        layout.gj_SetEqualSquareDistance(leftBtn, reference: rightBtn, leftDis: 1.20, topDis: 1.20, rightDis: 0, bottomDis: 1.20)
        //设置高
        layout.gj_SetWidthAndHeight(leftBtn, Width: 1.20, height: 40)
        //然后设置宽  这边用相等属性  
        //4.1 以一个view为参照物 来设置其相等的属性 一般相等属性 有 宽  高  上 下 左 右 边界六个  所以这边可以将全部列举出来 然后用1.20 来将不需要的 使其失效
        //这边是将 两者宽相等这样默认会将view的宽等分  然后是上下边界相等 （不需要设置高相等了 因为上下边界相等相当于设置了高相等）
        layout.gj_SetSixEqualForTwoEqualView(rightBtn, reference: leftBtn, widthEq: 0, heightEq: 1.20, leftEq: 1.20, topEq: 0, rightEq: 1.20, bottomEq: 0)
        //设置距离右边的距离
        layout.gj_SetSubSquareDistance(rightBtn, reference: mainView, leftDis: 1.20, topDis: 1.20, rightDis: -10, bottomDis: 1.20)
        
        //5.创建label的一些属性
        let label = UILabel()
        label.text = "texttexttexttexttexttexttexttexttext"
        cellViewOne.addSubview(label)
        //注：因为label 有自己根据字体来适应大小的能力 所以一般label 默认已经设置了宽高 两个属性 所以对于一般四个约束来确定一个控件的规则来说 label 只要两个约束就可以了
        //补充：另外label还有个特性 其本身的范围并不是字体的范围 ，但是同约束让其自适应大小可以获得其本身字体的范围
        //5.1 设置label的中心线 CenterY  CenterX
        //这边因为label 宽高是自适应的所以一句话就可以让其居中了 当然 也可以单独设置一个centerY 然后再设置一个左边的距离也行
        layout.gj_SetCenterXAndY(label, reference: cellViewOne, xDis: 0, yDis: 0)
        //5.2 设置label的边界 <= 或者 >= 
        //这边用lessthan 和 GreatThan 而且大于等于 和 小于等于 也分子视图和平级视图来分情况讨论的 这边介绍子视图  isLess等于 true 即为 小于等于  false 为大于等于
        layout.gj_SetSubLessOrGreaterThan(label, reference: cellViewOne, isLess: true, leftDis: 1.20, topDis: 1.20, rightDis: -10, bottomDis: 1.20)
        
        //至此 已经囊括了平时要用到的主要方法 至于其他方法 有待于以后遇到问题时候再开发
        
    }
    
    
    /**
     一键界面view添加
     
     - parameter mainView:   父视图
     - parameter subViewArr: 子视图数组
     */
    func viewAddSubViews(mainView:UIView,subViewArr:[UIView])
    {
        //遍历subViewArr 然后赋值 这边要按照顺序来
        for i in 0 ..< subViewArr.count
        {
            mainView.addSubview(subViewArr[i])
        }
 
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

