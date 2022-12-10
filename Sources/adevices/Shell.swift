import Foundation
import TSCBasic

/// Helper class that invoke other command line tool. It handles signal as well.
public final class Shell {

    public static let shared: Shell = Shell()

    public typealias TerminationHandler = () -> Void

    private var handlers: [TerminationHandler] = []

    private var signalSource: DispatchSourceSignal?

    public init() {

    }

    // Setup function before you use if you want to handle signals
    public func monitoringSignals() {
        // Make sure the signal does not terminate the application.
        signal(SIGINT, SIG_IGN)
        signalSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
        signalSource!.setEventHandler { [weak self] in
            if let strongSelf = self {
                for h in strongSelf.handlers {
                    h()
                }
            }
            exit(EXIT_FAILURE)
        }
        signalSource!.resume()
    }

    /// Run external command line tools
    /// synchronous. Use TSCBasic.Process because gets freeze when using Foundation.Process
    /// - Parameters:
    ///   - arguments: arguments include command itself
    ///   - processSet: ProcessSet to handle signals
    ///   - terminationHandler: callback when signal arrived
    /// - Returns: status code
    /// - Throws: exception from TSCBasic.Process
    public func run(arguments: [String], outputRedirection: TSCBasic.Process.OutputRedirection = .none, processSet: ProcessSet? = nil, terminationHandler: TerminationHandler? = nil, verbose: Bool = Process.verbose) throws -> (result: ProcessResult, statusCode: Int32) {
        if let h = terminationHandler {
            handlers.append(h)
        } else if let processSet = processSet {
            let handler = { processSet.terminate() }
            handlers.append(handler)
        }
        let result = try _run(arguments: arguments, outputRedirection: outputRedirection, processSet: processSet)

        switch result.exitStatus {
        case .signalled(let v):
            return (result, v)
        case .terminated(let v):
            return (result, v)
        }
    }
}

extension Shell {
    fileprivate func _run(arguments: [String], outputRedirection: TSCBasic.Process.OutputRedirection = .none, processSet: ProcessSet? = nil, verbose: Bool = Process.verbose) throws -> ProcessResult {
        let process = TSCBasic.Process.init(arguments: arguments, outputRedirection: outputRedirection, verbose: verbose)
        try process.launch()
        try processSet?.add(process)
        return try process.waitUntilExit()
    }
}
