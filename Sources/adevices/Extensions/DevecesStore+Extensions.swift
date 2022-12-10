import Foundation
import TSCBasic
import Path
import ArgumentParser
import Core


extension DevicesStore {

    /// Instantiate DevicesStore with active Xcode path by invoking `xcode-select` command.
    init(platform: Platform = .iPhone) throws {
        let result = try Shell.shared.run(
            arguments: ["xcode-select", "--print-path"],
            outputRedirection: .collect(redirectStderr: true),
            verbose: false
        )

        let value = try result.result.utf8Output().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let path = Path(value) else {
            throw "Something went wrong"
        }

        var xcodeAppBundlePath: Path = path
        while xcodeAppBundlePath.extension != "app" {
            xcodeAppBundlePath = xcodeAppBundlePath.parent

            if xcodeAppBundlePath == Path("/") {
                throw "Something went wrong"
            }
        }

        try self.init(xcode: xcodeAppBundlePath.url, platform: platform)
    }
}

extension DevicesStore.Platform: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument.lowercased())
    }
}
