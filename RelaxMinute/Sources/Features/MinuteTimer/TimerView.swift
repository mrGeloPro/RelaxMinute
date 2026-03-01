import SwiftUI

struct TimerView: View {
    @StateObject var viewModel: TimerViewModel
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            timerRing
            Spacer()
            controlButtons
        }
        .toolbar {
            toolbarContent
        }
        .background(.appBackground)
        .ignoresSafeArea()
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(newPhase: newPhase)
        }
    }
}

// MARK: - UI Components
private extension TimerView {
    
    var timerRing: some View {
        ZStack {

            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.ringTrack)
            Circle()
                .trim(from: 0.0, to: CGFloat(viewModel.progress))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentBlue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 0.01), value: viewModel.progress)
            Text(viewModel.timeString)
                .font(.system(size: 56, weight: .bold, design: .monospaced))
                .foregroundColor(.textPrimary)
                .accessibilityHidden(true)
        }
        .padding(40)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Timer")
        .accessibilityValue(viewModel.accessibilityTimeString)
    }
    
    var controlButtons: some View {
        HStack(spacing: 20) {

            Button(action: { viewModel.toggleStartPause() }) {
                HStack {
                    Image(viewModel.state == .running ? .pauseIcon : .startIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 15)
                    
                    Text(viewModel.state == .running ? "Pause" : "Start")
                        .font(.title2)
                        .padding(.horizontal, 8)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.solidBlue(role: .timer))
            
            Button(action: { viewModel.onShowStopAlert?() }) {
                HStack {
                    Image(.stopIcon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 15)
                    
                    Text("Stop")
                        .font(.title2)
                        .padding(.horizontal, 8)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.tonal(role: .destructive))
            .disabled(viewModel.state == .idle)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 40)
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Relax Minute")
                .font(.title)
                .foregroundColor(.textPrimary)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { viewModel.onShowInfo?() }) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.accentBlue)
            }
        }
    }
}

// MARK: - Helper Methods
private extension TimerView {
    func handleScenePhaseChange(newPhase: ScenePhase) {
        if newPhase == .active {
            viewModel.syncWithAppLifecycle(isActive: true)
        } else if newPhase == .background {
            viewModel.syncWithAppLifecycle(isActive: false)
        }
    }
}
