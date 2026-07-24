import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: JailbreakManager
    @State private var selectedPackage: PackageManager = .sileo
    
    enum PackageManager: String, CaseIterable {
        case sileo = "Sileo"
        case cydia = "Cydia"
        case darksword = "Darksword"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "iphone.and.arrow.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Benji's Jailbreak")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Picker("Select Package Manager", selection: $selectedPackage) {
                    ForEach(PackageManager.allCases, id: \.self) { pkg in
                        Text(pkg.rawValue).tag(pkg)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Status:")
                        .font(.headline)
                    ScrollView {
                        Text(manager.logOutput)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(height: 150)
                }
                .padding()
                
                Button(action: {
                    manager.startJailbreak(with: selectedPackage)
                }) {
                    Text(manager.isRunning ? "Jailbreaking..." : "Start Jailbreak")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(manager.isRunning ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(manager.isRunning)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}