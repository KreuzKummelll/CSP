import Foundation

public struct CSP<V: Hashable, D> {
    let variables: [V]
    let domains: [V:[D]]
    var constraints = Dictionary<V, [Constraint<V, D>]>()
    
    public init(variables: [V], domains: [V: [D]]) {
        self.variables = variables
        self.domains = domains
        for variable in variables {
            constraints[variable] = [Constraint]()
            if domains[variable] == nil {
                print("Error: Missing domain for variables \(variables)")
            }
        }
    }
    
    public mutating func addConstaint(_ constaint: Constraint<V, D>) {
        for variable in constaint.vars {
            if !variables.contains(variable) {
                print("Error: Could not find variable \(variable) from constraint \(constaint) in CSP")
            }
            constraints[variable]?.append(constaint)
        }
    }
}


open class Constraint <V: Hashable, D> {
    func isSatisfied(assignment: Dictionary<V, D>) -> Bool {
        return true
    }
    var vars: [V] {return [] }
}

public func backtrackingSearch<V, D>(csp: CSP<V,D>, assignment: Dictionary<V,D> = Dictionary<V,D>()) -> Dictionary<V,D>? {
    if assignment.count == csp.variables.count { return assignment}
    let unassigned = csp.variables.lazy.filter({assignment[$0] == nil })
    if let variable: V = unassigned.first, let domain = csp.domains[variable] {
        for value in domain {
            var localAssignment = assignment
            localAssignment[variable] = value
            if isConsistent(variable: variable, value: value, assignment: localAssignment, csp: csp) {
                if let result = backtrackingSearch(csp: csp, assignment: assignment) {
                    return result
                }
            }
        }
    }
    return nil
}

func isConsistent<V, D>(variable:V, value: D, assignment: Dictionary<V,D>, csp: CSP<V,D>) -> Bool {
    for constraint in csp.constraints[variable] ?? [] {
        if !constraint.isSatisfied(assignment: assignment) {
            return false
        }
    }
    return true
}



