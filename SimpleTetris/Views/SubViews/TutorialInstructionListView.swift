import SwiftUI

struct TutorialInstructionListView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "arrow.left")
                Text("左滑：方塊左移")
            }
            HStack {
                Image(systemName: "arrow.right")
                Text("右滑：方塊右移")
            }
            HStack {
                Image(systemName: "arrow.down")
                Text("下滑：方塊加速下落")
            }
            HStack {
                Image(systemName: "hand.tap")
                Text("輕按：方塊旋轉")
            }
            HStack {
                Image(systemName: "hand.point.up.left.fill")
                Text("長按：直接落到底")
            }
            HStack {
                Image(systemName: "list.number")
                Text("分數：遊戲結束後會自動儲存，可在設定頁查看")
            }
        }
        .font(.title3)
    }
}
