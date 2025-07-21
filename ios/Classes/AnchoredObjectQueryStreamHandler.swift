//
//  AnchoredObjectQueryStreamHandler.swift
//  health_kit_reporter
//
//  Created by Victor Kachalov on 09.12.20.
//

import Foundation
import HealthKitReporter
import HealthKit

public final class AnchoredObjectQueryStreamHandler: NSObject {
    public let reporter: HealthKitReporter
    public var activeQueries = Set<Query>()
    public var plannedQueries = Set<Query>()

    init(reporter: HealthKitReporter) {
        self.reporter = reporter
    }
    
    // MARK: - Anchor Cache Management
    
    /// 获取本地缓存的anchor
    private func getCachedAnchor(for identifier: String) -> HKQueryAnchor? {
        let key = "anchor_cache_\(identifier)"
        guard let base64String = UserDefaults.standard.string(forKey: key),
              let data = Data(base64Encoded: base64String) else {
            return nil
        }
        
        do {
            let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
            return anchor
        } catch {
            print("Failed to unarchive anchor for \(identifier): \(error)")
            return nil
        }
    }
    
    /// 保存anchor到本地缓存
    private func saveCachedAnchor(_ anchor: HKQueryAnchor, for identifier: String) {
        let key = "anchor_cache_\(identifier)"
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: false)
            let base64String = data.base64EncodedString()
            UserDefaults.standard.set(base64String, forKey: key)
        } catch {
            print("Failed to archive anchor for \(identifier): \(error)")
        }
    }
    
    /// 清除指定标识符的anchor缓存
    private func clearCachedAnchor(for identifier: String) {
        let key = "anchor_cache_\(identifier)"
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - StreamHandlerProtocol
extension AnchoredObjectQueryStreamHandler: StreamHandlerProtocol {
    public func setQueries(arguments: [String: Any], events: @escaping FlutterEventSink) throws {
        guard
            let identifiers = arguments["identifiers"] as? [String],
            let startTimestamp = arguments["startTimestamp"] as? Double,
            let endTimestamp = arguments["endTimestamp"] as? Double
        else {
            return
        }
        
        // 新增：控制是否使用本地缓存的anchor
        let useCachedAnchor = arguments["useCachedAnchor"] as? Bool ?? false
        
        let predicate = NSPredicate.samplesPredicate(
            startDate: Date.make(from: startTimestamp),
            endDate: Date.make(from: endTimestamp)
        )
        
        for identifier in identifiers {
            guard let type = identifier.objectType as? SampleType else {
                return
            }
            
            // 获取缓存的anchor（如果启用缓存功能）
            var cachedAnchor: HKQueryAnchor? = nil
            if useCachedAnchor {
                cachedAnchor = getCachedAnchor(for: identifier)
            }
            
            let query = try reporter.reader.anchoredObjectQuery(
                type: type,
                predicate: predicate,
                anchor: cachedAnchor,
                monitorUpdates: true
            ) { (query, samples, deletedObjects, anchor, error) in
                guard error == nil else {
                    return
                }
                
                // 保存新的anchor到本地缓存
                if let anchor = anchor {
                    self.saveCachedAnchor(anchor, for: identifier)
                }
                
                var jsonDictionary: [String: Any] = [:]
                var samplesArray: [String] = []
                for sample in samples {
                    do {
                        let encoded = try sample.encoded()
                        samplesArray.append(encoded)
                    } catch {
                        continue
                    }
                }
                var deletedObjectsArray: [String] = []
                for deletedObject in deletedObjects {
                    do {
                        let encoded = try deletedObject.encoded()
                        deletedObjectsArray.append(encoded)
                    } catch {
                        continue
                    }
                }
                jsonDictionary["samples"] = samplesArray
                jsonDictionary["deletedObjects"] = deletedObjectsArray
                jsonDictionary["identifier"] = identifier // 添加标识符信息
                
                // 确保在主线程上发送消息到Flutter
                DispatchQueue.main.async {
                    events(jsonDictionary)
                }
            }
            plannedQueries.insert(query)
        }
    }

    public static func make(with reporter: HealthKitReporter) -> AnchoredObjectQueryStreamHandler {
        AnchoredObjectQueryStreamHandler(reporter: reporter)
    }
}
// MARK: - FlutterStreamHandler
extension AnchoredObjectQueryStreamHandler: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        handleOnListen(withArguments: arguments, eventSink: events)
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        handleOnCancel(withArguments: arguments)
    }
}
