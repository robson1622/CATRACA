import Foundation

class ArchiveController {
    static let shared = ArchiveController()
    private let listName: String = "listOfFiles.json"
    private let fileManager = FileManager.default

    private struct FileModel: Codable {
        var route: RouteModel
        var directions: DirectionsModel
    }

    func loadRoutes() -> [RouteModel] {
        var routes: [RouteModel] = []
        let fileList = loadFileList()

        for fileName in fileList {
            let fileURL = getFileURL(for: fileName)
            if let fileModel = loadFile(fileURL: fileURL) {
                routes.append(fileModel.route)
            }
        }
        return routes
    }

    func loadDirections() -> [DirectionsModel] {
        var directions: [DirectionsModel] = []
        let fileList = loadFileList()

        for fileName in fileList {
            let fileURL = getFileURL(for: fileName)
            if let fileModel = loadFile(fileURL: fileURL) {
                directions.append(fileModel.directions)
            }
        }
        return directions
    }

    func saveFile(route: RouteModel, directions: DirectionsModel) {
        let fileName = route.id
        let fileURL = getFileURL(for: fileName)
        let fileModel = FileModel(route: route, directions: directions)

        do {
            let jsonData = try JSONEncoder().encode(fileModel)
            try jsonData.write(to: fileURL, options: .atomic)
            saveFileNameToList(fileName)
        } catch {
            print("Erro ao salvar arquivo: \(error.localizedDescription)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private func getFileURL(for fileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(fileName).json")
    }

    private func getListFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(listName)
    }
    
    private func saveFileNameToList(_ fileName: String) {
        var fileList = loadFileList()
        if !fileList.contains(fileName) {
            fileList.append(fileName)
            do {
                let jsonData = try JSONEncoder().encode(fileList)
                try jsonData.write(to: getListFileURL(), options: .atomic)
            } catch {
                print("Erro ao salvar lista de arquivos: \(error.localizedDescription)")
            }
        }
    }

    private func loadFileList() -> [String] {
        let listURL = getListFileURL()
        guard fileManager.fileExists(atPath: listURL.path) else { return [] }

        do {
            let data = try Data(contentsOf: listURL)
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Erro ao carregar lista de arquivos: \(error.localizedDescription)")
            return []
        }
    }

    

    private func loadFile(fileURL: URL) -> FileModel? {
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }

        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(FileModel.self, from: data)
        } catch {
            print("Erro ao carregar arquivo: \(error.localizedDescription)")
            return nil
        }
    }
}
