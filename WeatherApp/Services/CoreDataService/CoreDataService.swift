//
//  CoreDataService.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import CoreData

protocol ICoreDataService {
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    
    func fetch<T: NSManagedObject>(
        _ managedObject: T.Type,
        completion: (Result<[T], Error>) -> Void
    )
    
    func delete(
        _ currentObject: NSManagedObject,
        context: NSManagedObjectContext
    )
}

protocol ICoreDataLocationService: ICoreDataService {
    
    func save(
        _ model: LocationCoreDataModel,
        context: NSManagedObjectContext
    )
}

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "WeatherForecastAppDataModel"
        )
        container.loadPersistentStores { description, error in
            //
        }
        return container
    }()
    
    private lazy var readContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    private init() {}
}

extension CoreDataService: ICoreDataService {
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = writeContext
        context.perform {
            block(context)
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetch<T>(
        _ managedObject: T.Type,
        completion: (Result<[T], Error>) -> Void
    ) where T : NSManagedObject {
        let fetchRequest = NSFetchRequest<T>(
            entityName: String(describing: T.self)
        )
        
        do {
            let dbObject = try readContext.fetch(fetchRequest)
            completion(.success(dbObject))
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete(_ currentObject: NSManagedObject, context: NSManagedObjectContext) {
        let objectID = currentObject.objectID
        let currentObject = context.object(with: objectID)
        context.delete(currentObject)
    }
}

extension CoreDataService: ICoreDataLocationService {
    func save(_ model: LocationCoreDataModel, context: NSManagedObjectContext) {
        let dbLocation = DBLocation(context: context)
        dbLocation.id = model.id
        dbLocation.cityName = model.cityName
        dbLocation.latitude = model.latitude
        dbLocation.longitude = model.longitude
        dbLocation.country = model.country
        dbLocation.state = model.state
    }
}
