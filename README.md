# swift-ofo
模仿小黄车

![image](https://github.com/yanmingLiu/swift-ofo/blob/master/ofo_2/QQ20190613-184941%402x.png)

基本实现功能：
1. 二维码扫描
2. 底部UI弹起、隐藏
3. UIBezierPath画圆弧y效果
4. 地图展示、拖拽、缩放、定位、自定义大头针气泡
5. 通知展示
6. POI搜索附近的'餐馆'

```
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

```

7.路线规划

```
///画线代理
func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {

    if overlay is MAPolyline {
        // 大头针固定
        pin.isLockedToScreen = false

        // 缩放地图显示线
        mapView.visibleMapRect = overlay.boundingMapRect

        let render = MAPolylineRenderer(overlay: overlay)
        render?.lineWidth = 4.0
        render?.strokeColor = #colorLiteral(red: 0.4666666687,   green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return render
    }
return nil
}
```

