//
//  PlayerSpec.swift
//  Stasis
//
//  Created by Eli Perkins on 12/19/14.
//  Copyright (c) 2014 eliperkins. All rights reserved.
//

import Quick
import Nimble
import Stasis

class PlayerSpec: QuickSpec {
    override func spec() {
        it("should transform from JSON") {
            // Apparently this JSON was too complex for Swift to compile
            // Removing the empty array (no type), and the nil value seem to
            // appease Swift for the time being.
            let JSON: [String : AnyObject] = [
//                "aliases": [], // lolswift
                "birthday": "1995-01-01",
                "country": "KR",
                "current_rating": [
                    "decay": 0,
                    "dev": 0.106688038904545,
                    "dev_vp": 0.121775916101883,
                    "dev_vt": 0.106544143627192,
                    "dev_vz": 0.101925462037805,
                    "id": 5192378,
                    "rating": 1.22403765947284,
                    "rating_vp": -0.0241462525366756,
                    "rating_vt": -0.0413275146729788,
                    "rating_vz": 0.0654737672096545,
                    "resource_uri": "/api/v1/rating/5192378/",
                    "tot_vp": 1.1998914069361644,
                    "tot_vt": 1.1827101447998611,
                    "tot_vz": 1.2895114266824945
                ],
                "current_teams": [
                    [
//                        "end": nil, // lolswift
                        "id": 171,
                        "playing": true,
                        "resource_uri": "",
                        "start": "2012-03-29",
                        "team": [
                            "id": 18,
                            "name": "Team Liquid",
                            "resource_uri": "/api/v1/team/18/",
                            "shortname": "Liquid"
                        ]
                    ]
                ],
                "dom_end": "/api/v1/period/103/",
                "dom_start": "/api/v1/period/57/",
                "dom_val": 1.46605571508888,
                "id": 6,
                "lp_name": "TaeJa",
                "mcnum": 1,
                "name": "윤영서",
                "past_teams": [
                    [
                        "end": "2012-03-13",
                        "id": 406,
                        "playing": true,
                        "resource_uri": "",
                        "start": "2011-05-01",
                        "team": [
                            "id": 47,
                            "name": "SlayerS",
                            "resource_uri": "/api/v1/team/47/",
                            "shortname": "SlayerS"
                        ]
                    ],
                    [
                        "end": "2011-05-01",
                        "id": 439,
                        "playing": true,
                        "resource_uri": "",
                        "start": "2011-03-01",
                        "team": [
                            "id": 65,
                            "name": "ZeNEX",
                            "resource_uri": "/api/v1/team/65/",
                            "shortname": "ZeNEX"
                        ]
                    ]
                ],
                "race": "T",
                "resource_uri": "/api/v1/player/6/",
                "romanized_name": "Yun Young Seo",
                "sc2e_id": 285,
                "tag": "TaeJa",
                "tlpd_db": 3,
                "tlpd_id": 1849
            ]
            
            let player = Player.transform(JSON)
            
            expect(player.name).to(equal("윤영서"))
            expect(player.race).to(equal(Race.Terran))
            expect(player.romanizedName).to(equal("Yun Young Seo"))
            expect(player.tag).to(equal("TaeJa"))
            expect(player.team).notTo(beNil())
            expect(player.remoteID).to(equal(6))
            expect(player.country).to(equal("KR"))
        }
    }
}
