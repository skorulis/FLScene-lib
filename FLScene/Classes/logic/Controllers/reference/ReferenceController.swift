//
//  ReferenceController.swift
//  floatios
//
//  Created by Alexander Skorulis on 1/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SKSwiftLib

#if os(iOS)
//import FontAwesomeKit
#endif

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

public class ReferenceController {

    public let items:[String:ItemReferenceModel]
    public let story:[String:StoryReferenceModel]
    public let skills:[SkillType:SkillReferenceModel]
    public let actions:[ActionType:ActionReferenceModel]
    public let dungeonTiles:[DungeonTileType:DungeonTileReferenceModel]
    public let terrain:[TerrainType:TerrainReferenceModel]
    public let monsters:[String:MonsterReferenceModel]
    
    init() {
        let itemArray = ReferenceController.makeItems()
        items = itemArray.groupSingle { $0.name }
        story = ReferenceController.makeStory().groupSingle { $0.key }
        skills = ReferenceController.makeSkills().groupSingle { $0.name }
        actions = ReferenceController.makeActions().groupSingle { $0.type }
        dungeonTiles = ReferenceController.makeDungeonTiles().groupSingle { $0.type }
        
        terrain = ReferenceController.readReferenceObjects(filename: "terrain").groupSingle { $0.type}
        monsters = ReferenceController.readReferenceObjects(filename: "monsters").groupSingle { $0.name}
    }
    
    static func makeStory() -> [StoryReferenceModel] {
        let start = StoryReferenceModel(key: "start", story: "You open your eyes to unfamiliar surroundings with no memory of how you came to be here. You sit up and rub your head to try to remember, all you can think of is your name")
        let needSleep = StoryReferenceModel(key: "start_sleep", story: "At least you can remember that much, by the time you senses return a litt the sun is alread going down, you decide to sleep and see what you can find in the morning")
        
        
        return [start,needSleep]
    }
    
    static func makeItems() -> [ItemReferenceModel] {
        let food = ItemReferenceModel(name: "Food", description: "Something you can eat")
        let ether = ItemReferenceModel(name: "Ether", description: "Should link to lore article")
        let minerals = ItemReferenceModel(name: "Minerals", description: "Generic minerals")
        let wood = ItemReferenceModel(name: "Wood", description: "Generic wood")
        
        return [food,ether,minerals,wood]
    }
    
    static func makeSkills() -> [SkillReferenceModel] {
        return [SkillReferenceModel(name: .foraging),SkillReferenceModel(name: .lumberjacking),SkillReferenceModel(name: .mining)]
    }
    
    static func makeActions() -> [ActionReferenceModel] {
        
        let sleep = ActionReferenceModel(type: .sleep)
        
        let eat = ActionReferenceModel(type: .eat,
                                       reqs:[RequirementModel.time(value: 5),
                                            RequirementModel.item(name: "Food", value: 1)])
        
        let explore = ActionReferenceModel(type: .explore,
                                           reqs:[RequirementModel.time(value: 30),
                                                 RequirementModel.satiation(value: 10)])
        
        let forage = ActionReferenceModel(type: .forage,
                                          reqs: [RequirementModel.skill(type: .foraging),
                                                 RequirementModel.time(value: 10),
                                                 RequirementModel.satiation(value: 5)])
        
        let mine = ActionReferenceModel(type: .mine,
                                        reqs: [RequirementModel.skill(type: .mining),
                                               RequirementModel.time(value: 20),
                                               RequirementModel.satiation(value: 10)])
        
        let lumberjack = ActionReferenceModel(type: .lumberjack,
                                              reqs:[RequirementModel.skill(type: .lumberjacking),
                                                    RequirementModel.time(value: 20),
                                                    RequirementModel.satiation(value: 10)])
        
        let dungeon = ActionReferenceModel(type: .dungeon,
                                           reqs:[RequirementModel.time(value: 100),
                                                 RequirementModel.satiation(value: 10)])
        
        #if os(iOS)
        /*let iconSize = CGFloat(30)
        sleep.icon = FAKFontAwesome.moonOIcon(withSize: iconSize)
        eat.icon = FAKFontAwesome.appleIcon(withSize: iconSize)
        explore.icon = FAKFontAwesome.binocularsIcon(withSize: iconSize)
        forage.icon = FAKFontAwesome.pawIcon(withSize: iconSize)
        mine.icon = FAKFontAwesome.wrenchIcon(withSize: iconSize)
        lumberjack.icon = FAKFontAwesome.treeIcon(withSize: iconSize)
        dungeon.icon = FAKFontAwesome.fortAwesomeIcon(withSize: iconSize)*/
        #endif
        
        return [sleep,eat,forage,mine,lumberjack,explore,dungeon]
    }
    
    private static func makeDungeonTiles() -> [DungeonTileReferenceModel] {
        let wall = DungeonTileReferenceModel(type: .wall, canPass: false)
        let stairUp = DungeonTileReferenceModel(type:.stairsUp,canPass: true,actions:[.goUp])
        let stairDown = DungeonTileReferenceModel(type:.stairsDown,canPass: true,actions:[.goDown])
        let teleporter = DungeonTileReferenceModel(type:.teleporter,canPass:true,actions:[])
        return [wall,stairUp,stairDown,teleporter]
    }
    
    public func getItem(name:String) -> ItemReferenceModel {
        return items[name]!
    }
    
    public func getStory(key:String) -> StoryReferenceModel {
        return story[key]!
    }
    
    public func getSkill(type:SkillType) -> SkillReferenceModel {
        return skills[type]!
    }
    
    public func getAction(type:ActionType) -> ActionReferenceModel {
        return actions[type]!
    }
    
    public func getDungeonTile(type:DungeonTileType) -> DungeonTileReferenceModel {
        return dungeonTiles[type]!
    }
    
    public func getDungeonTile(name:String) -> DungeonTileReferenceModel {
        let type = DungeonTileType.init(rawValue: name)!
        return getDungeonTile(type: type)
    }
    
    public func getTerrain(type:TerrainType) -> TerrainReferenceModel {
        return terrain[type]!
    }
    
    public func allActions() -> [ActionReferenceModel] {
        return actions.values.map { $0 }
    }
    
    public func randomSkill() -> SkillReferenceModel {
        let all = Array(skills.values)
        let index = arc4random_uniform(UInt32(all.count))
        return all[Int(index)]
    }
    
    public class func readReferenceObjects<T: Decodable>(filename:String) -> [T] {
        do {
            let bundle = Bundle.init(for: self)
            let path = bundle.path(forResource: filename, ofType: "json")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let objects = try decoder.decode([T].self, from: data)
            return objects
        } catch {
            
        }
        return []
    }
    
}
