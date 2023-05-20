//
//  BoolExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/19/23.
//

import RxCocoa
import RxSwift
import UIKit

extension Binder<Bool> {
    var not: AnyObserver<Bool> {
        return self.mapObserver { !$0 }
    }
}
