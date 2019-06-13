//
//  ViewController.swift
//  ofo_2
//
//  Created by lym on 2017/10/30.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

import UIKit
//import RxCocoa
//import RxSwift
import FTIndicator


let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height
let StateBarH = UIApplication.shared.statusBarFrame.height
let NavgationH = UINavigationBar.appearance().frame.height

let panelViewH : CGFloat = ScreenW * 0.83


class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate, AMapNaviWalkManagerDelegate {

    var panelView: PanelView!
    let rightView = RightButtonsView()
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var pin : MyPinAnnotation!
    var pinView : MAPinAnnotationView!
    var nearbySearch = true 
    var start,end :CLLocationCoordinate2D! // 起点终点
    var walkManager: AMapNaviWalkManager!
    var oldAnnotations = [MAPointAnnotation]() // 旧的标记
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color + 回车
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        setupMapView()
        
        setupSubViews()

    }
    
    // MARK: 初始化子视图
    func setupSubViews() -> () {
        panelView = PanelView.init(frame: CGRect(x: 0, y: (ScreenH - panelViewH), width: ScreenW, height: panelViewH))
        view.addSubview(panelView)
        
        let rightViewFrame = CGRect(x: ScreenW - 50, y: panelView.frame.minY - 80, width: 44, height: 100)
        rightView.frame = rightViewFrame
        view.addSubview(rightView)
        
        let logoView = LogoView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: StateBarH + 80))
        view.addSubview(logoView)
        
        rightView.loctionBtn.addTarget(self, action: #selector(location), for: .touchUpInside)
    }
    
    // MARK: 地图设置
    func setupMapView() -> () {

        mapView = MAMapView(frame: view.frame)
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.zoomLevel = 15
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isRotateEnabled = false
        mapView.showsCompass = false
        
        search = AMapSearchAPI()
        search.delegate = self
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self;
    }
    
    //MARK: - 功能
    
    ///定位按钮
    @objc func location() {
        pin.isLockedToScreen = true
        nearbySearch = true
        // 去掉之前的线
        mapView.removeOverlays(mapView.overlays)
        // 搜索附近
        searchBikeNearby()
    }

    ///搜索周边
    func searchBikeNearby() {
        let coord = mapView.userLocation.coordinate
        print(coord)
        searchCustomLocation(coord)
    }
    
    ///POI
    func searchCustomLocation(_ center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 500
        request.requireExtension = true
        request.requireSubPOIs = true
        search.aMapPOIAroundSearch(request)
    }
    
    //MARK: - MAMapViewDelegate
    
    ///地图初始化完成后调用
    func mapInitComplete(_ mapView: MAMapView!) {
        // 添加地图中间固定大头钉
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate
        pin.lockedScreenPoint = mapView.center
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        
        location()
    }
    
    ///自定义气泡
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        print("address: \(String(describing: view.annotation.title))\(String(describing: view.annotation.subtitle))")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAUserLocation {
            return nil;
        }
        // 自定义大头针
        if annotation is MyPinAnnotation {
            let reuseid = "center"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            annotationView?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            annotationView?.canShowCallout = false
            
            pinView = annotationView as! MAPinAnnotationView
            return annotationView
        }
        
        // 搜索结果大头针
        if annotation.isKind(of: MAPointAnnotation.self) {
            let reuseid = "myid"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            if annotation.title == "正常使用" {
                annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
            } else {
                annotationView?.image = #imageLiteral(resourceName: "HomePage_ParkRedPack")
            }
            
            annotationView?.canShowCallout = true
            return annotationView
        }
        
        return nil
    }
    
    /// 给出了固定大头针 pinview 之外的标注添加动画
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        
        let aviews = views as! [MAAnnotationView]    
        
        for aview in aviews {
            // 保证aview 是 MAPinAnnotationView
            if aview.annotation is MyPinAnnotation  {
                return
            }
            aview.transform = CGAffineTransform(scaleX: 0, y: 0)
            // 添加动画
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: { 
                aview.transform = .identity
            }, completion:nil)
        }
    }
    
    ///用户移动地图后调用
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction && pin.isLockedToScreen {
            // 添加动画
            self.pinAnimation()
            searchCustomLocation(mapView.centerCoordinate)
        }
    }
    
    ///点击大头针
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        start = pin.coordinate
        end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))
        
        walkManager.calculateWalkRoute(withStart: [startPoint!], end: [endPoint!])
    }
    
    ///画线代理
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            
            // 大头针固定
            pin.isLockedToScreen = false
            
            // 缩放地图显示线
            mapView.visibleMapRect = overlay.boundingMapRect
            
            let render = MAPolylineRenderer(overlay: overlay)
            render?.lineWidth = 4.0
            render?.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            return render
        }
        return nil
    }
    
    // MARK: - AMapSearchDelegate
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count == 0 {
            print("周边没有小黄车")
            return
        }
        var annotations : [MAPointAnnotation] = []
        annotations = response.pois.map {

            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if $0.distance < 100 {
                annotation.title = "红包车内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得现金红包"
            }else {
                annotation.title = "正常使用"
            }
            oldAnnotations.append(annotation)
            return annotation
        }

        // 添加标注
        mapView.removeAnnotations(oldAnnotations)
        mapView.addAnnotations(annotations)
        
        if nearbySearch {
            mapView.showAnnotations(annotations, animated: true)
            nearbySearch = !nearbySearch
        }
        
    }
    
    /// 大头针动画
    func pinAnimation() {
        
        let endFrame = pinView.frame

        /// y轴位移
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
        // 弹性动画
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { 
            self.pinView.frame = endFrame
        }, completion: nil)
    }
    
    // MARK: - AMapNaviWalkManagerDelegate 步行代理
    
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("步行路线规划成功")
        
        // 去掉之前的线
        mapView.removeOverlays(mapView.overlays)
        
        //显示路径或开启导航
        var coordinates = walkManager.naviRoute?.routeCoordinates.map {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        
        let polyline: MAPolyline = MAPolyline(coordinates: &coordinates!, count: UInt(coordinates!.count))
        
        mapView.add(polyline)
        
        // 提示距离和时间
        let walkTime = (walkManager.naviRoute?.routeTime)! / 60
        
        var timeTips = "不满1分钟"
        if walkTime > 0 {
            timeTips = walkTime.description + "分钟"
        }
        let hintTitle = "步行" + timeTips
        let hintSubTitle = "距离" + (walkManager.naviRoute?.routeLength.description)! + "米"
        
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubTitle)
    }
    
    func walkManager(_ walkManager: AMapNaviWalkManager, error: Error) {
        print("路线规划失败------ ", error)
    }

}

