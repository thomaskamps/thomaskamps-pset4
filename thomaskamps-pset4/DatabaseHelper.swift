//
//  DatabaseHelper.swift
//  thomaskamps-pset4
//
//  Created by Thomas Kamps on 24-11-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    private let todos = Table("todos")
    
    private let id = Expression<Int64>("id")
    private let todo = Expression<String>("todo")
    private let done = Expression<Bool>("done")
    
    private var db: Connection?
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        
        do {
            try db!.run(todos.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(todo)
                t.column(done)
            })
        } catch {
            throw error
        }
    }
    
    func create(todo: String) throws {
        
        let insert = todos.insert(self.todo <- todo, self.done <- false)
        
        do {
            let rowId = try db!.run(insert)
        } catch {
            throw error
        }
    }
    
    func read() throws -> Array<Any> {
        
        var result: Array<Dictionary<String, Any>> = []
        
        do {
            for res in try db!.prepare(todos) {
                let resDict = ["id": res[id], "todo": res[todo], "done": res[done]] as [String : Any]
                result.append(resDict)
            }
        } catch {
            throw error
        }
        return result
    }
    
    func editDone(id: Int64, done: Bool) throws {
        
        let currentEdit = todos.filter(self.id == id)
        
        do {
            if try db?.run(currentEdit.update(self.done <- done)) != 1 {
                print("Update encountered problems..")
            }
        } catch {
            throw error
        }
    }
    
    func remove(id: Int64) throws {
        
        let currentEdit = todos.filter(self.id == id)
        
        do {
            if try db?.run(currentEdit.delete()) != 1 {
                print("Remove action encountered problem..")
            }
        } catch {
            throw error
        }
    }
}
