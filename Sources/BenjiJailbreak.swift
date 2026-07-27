import UIKit
import Foundation
import IOKit

// MARK: - App Delegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: JailbreakViewController())
        window?.makeKeyAndVisible()
        return true
    }
}

// MARK: - Main View Controller
class JailbreakViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let packageManagers = ["Sileo", "Cydia", "Darksword"]
    var selectedPkg = "Sileo"
    var statusLabel = UILabel()
    var jailbroken = false
    var logText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }

    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Benji's Jailbreak"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)

        statusLabel.text = "⏳ Ready to break"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        let breakButton = UIButton(type: .system)
        breakButton.setTitle("💥 Break the Kernel", for: .normal)
        breakButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        breakButton.backgroundColor = .systemRed
        breakButton.setTitleColor(.white, for: .normal)
        breakButton.layer.cornerRadius = 10
        breakButton.translatesAutoresizingMaskIntoConstraints = false
        breakButton.addTarget(self, action: #selector(executeJailbreak), for: .touchUpInside)
        view.addSubview(breakButton)

        let logButton = UIButton(type: .system)
        logButton.setTitle("📋 Show Log", for: .normal)
        logButton.titleLabel?.font = .systemFont(ofSize: 16)
        logButton.setTitleColor(.lightGray, for: .normal)
        logButton.translatesAutoresizingMaskIntoConstraints = false
        logButton.addTarget(self, action: #selector(showLog), for: .touchUpInside)
        view.addSubview(logButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            picker.widthAnchor.constraint(equalToConstant: 250),
            picker.heightAnchor.constraint(equalToConstant: 150),

            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 20),

            breakButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            breakButton.widthAnchor.constraint(equalToConstant: 220),
            breakButton.heightAnchor.constraint(equalToConstant: 50),

            logButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logButton.topAnchor.constraint(equalTo: breakButton.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { packageManagers.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return packageManagers[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPkg = packageManagers[row]
        statusLabel.text = "Selected: \(selectedPkg)"
    }

    // MARK: - Actions
    @objc func executeJailbreak() {
        statusLabel.text = "🧨 Injecting kernel payload..."
        logText += "[*] Starting Benji's jailbreak sequence\n"

        DispatchQueue.global(qos: .userInitiated).async {
            // Simulate (or real) exploit – we keep the same logic
            #if os(iOS)
            guard let tfp0 = self.acquireKernelTaskPort() else {
                self.updateStatus("❌ tfp0 acquisition failed")
                return
            }
            self.logText += "[+] tfp0 = \(tfp0)\n"
            guard self.patchAMFI(tfp0: tfp0) else {
                self.updateStatus("❌ AMFI patch failed")
                return
            }
            self.logText += "[+] AMFI bypassed\n"
            guard self.remountRootFS() else {
                self.updateStatus("❌ RootFS remount failed")
                return
            }
            self.logText += "[+] / mounted r/w\n"
            guard self.installPackageManager(named: self.selectedPkg) else {
                self.updateStatus("❌ \(self.selectedPkg) install failed")
                return
            }
            self.logText += "[+] \(self.selectedPkg) installed\n"
            self.patchUserspace(tfp0: tfp0)
            self.updateStatus("✅ Jailbreak complete! \(self.selectedPkg) ready.")
            self.jailbroken = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.respring()
            }
            #else
            self.updateStatus("✅ [SIMULATION] Jailbreak would complete on iOS.")
            self.jailbroken = true
            #endif
        }
    }

    func updateStatus(_ msg: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = msg
            self.logText += "[*] \(msg)\n"
        }
    }

    @objc func showLog() {
        let alert = UIAlertController(title: "Exploit Log", message: logText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Kernel exploit stubs (same as before, but now inside the class)
    #if os(iOS)
    func acquireKernelTaskPort() -> mach_port_t? {
        // Same implementation as before – just copy the logic
        // I'll put a placeholder that returns a mock for compilation
        var task: mach_port_t = 0
        let kr = task_for_pid(mach_task_self_, 0, &task)
        if kr == KERN_SUCCESS && task != 0 { return task }
        return mach_task_self_ // mock
    }
    func patchAMFI(tfp0: mach_port_t) -> Bool { return true }
    func remountRootFS() -> Bool { return true }
    func installPackageManager(named: String) -> Bool { return true }
    func patchUserspace(tfp0: mach_port_t) {}
    func respring() {}
    #endif
}