//
//  SwiftyUserDefaults+.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import SwiftyUserDefaults

// An extension that sets up our default keys, this is much more modern than the vanilla one
// apple likes to provide
extension DefaultsKeys {
	static let jwt = DefaultsKey<String>("jwt")
}
