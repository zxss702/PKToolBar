# PKToolBar
Apple PencilKit ToolBar rebuild By SwiftUI

__使用swiftUI重新构建的苹果Pencilkit的工具栏__

此工具栏是noteE中所附带的，使用苹果PKtool的工具栏的附属品

基本上完整的复刻了所有的苹果PKtoolBar的功能，包括但不限于具备自动储存上次选择的工具，笔，铅笔，标记笔，选择笔，尺子橡皮，颜色选择，自定义颜色，可拖拽，宽度选择等功能

您可以在App Store上下载noteE体验此工具栏(https://apps.apple.com/us/app/notee/id1669201695）

## 预览图
![noteE中的Bar](https://user-images.githubusercontent.com/81460660/230101744-440294db-6c9e-4a32-ab4b-b2a5bbe18713.jpeg)

## 使用方法
将您本库中的所有文件下载到您的主程序中
```
struct ToolView: View {
    @StateObject var manage : rootvar
    
    var body: some View {
        PKCanvasView()
            .overlay {
                PKToolPickerView()
            }
            .environmentObject( manage)
    }
}
```
```
struct PKCanvasView:UIViewrRepresentable {
    @EnvironmentObject var manage:rootvar
    
    ...//你的 mackView
    
    func updateUIViewController(_ uiViewController: PKCanvasView, context: Context) {
        switch manage.PKToolSlect {
        case .Pen:
            uiViewController.PKcanvasView.tool = PKInkingTool(.pen, color: manage.PenColor.UIColor.withAlphaComponent(manage.PenAlpha), width: manage.PenWidth)
        case .Marker:
            uiViewController.PKcanvasView.tool = PKInkingTool(.marker, color: manage.MarkerColor.UIColor.withAlphaComponent(manage.MarkerAlpha), width: manage.MarkerWidth)
        case .Pencil:
            uiViewController.PKcanvasView.tool = PKInkingTool(.pencil, color: manage.PencilColor.UIColor.withAlphaComponent(manage.PencilAlpha), width: manage.PencilWidth)
        case .Lasso:
            uiViewController.PKcanvasView.tool = PKLassoTool()
        case .Eraser:
            uiViewController.PKcanvasView.tool = PKEraserTool(manage.EraserisFull ? .vector : .bitmap)
        }
        uiViewController.PKcanvasView.isRulerActive = manage.isRuler
    }
    
}

```
