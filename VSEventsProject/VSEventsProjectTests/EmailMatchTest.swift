//
//  EmailMatchTest.swift
//  VSEventsProjectTests
//
//  Created by Virgilius Santos on 20/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import VSEventsProject

class EmailMatchTest: QuickSpec {
    override func spec() {
        it("validacao de formato de email") {
            expect("admin@admin.com".match(.email))
                .to(beTrue())

            expect("admin.gh@admin.com".match(.email))
                .to(beTrue())

            expect("admin_uiu@admin.com".match(.email))
                .to(beTrue())

            expect("admin@admin.com.ki".match(.email))
                .to(beTrue())

            expect("7777uuuuu".match(.email))
                .to(beFalse())

            expect("awewe@l".match(.email))
                .to(beFalse())

            expect("@lrrttrert".match(.email))
                .to(beFalse())

            expect("".match(.email))
                .to(beFalse())

            expect("@".match(.email))
                .to(beFalse())
        }
    }
}
