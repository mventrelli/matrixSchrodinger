//
//  1dsolutions.swift
//  matrixSchrodinger
//
//  Created by IIT PHYS 440 on 2/17/23.
//

import SwiftUI

class _dsolutions: NSObject {
    func psi(n: Int, x: Double, L: Double) -> Double {
        let sqrt2L = sqrt(2/L)
        let _ = sqrt(2)
        let k = Double(n) * Double.pi / L
        return sqrt2L * sin(k * x) + sqrt2L * sin(k * (2 * L - x))
    }
    func hamiltonian(n: Int, m: Int, L: Double, hbar: Double, mass: Double) -> Double {
        if n == m {
            let E_n = pow(Double(n), 2) * pow(Double.pi, 2) * hbar * hbar / (2 * mass * L * L)
            return E_n
        } else {
            let prefactor = -4 * pow(-1, Double(n+m)) / (pow(Double(n) + Double(m), 2) * pow(Double.pi, 2))
            let H_nm = prefactor * pow(Double.pi, 2) * hbar * hbar / (2 * mass * L * L)
            return H_nm
        }
    }
    
    func hamiltonianMatrix(nMax: Int, L: Double, hbar: Double, mass: Double) -> [[Double]] {
        var H = Array(repeating: Array(repeating: 0.0, count: nMax), count: nMax)
        
        for n in 0..<nMax {
            for m in 0..<nMax {
                H[n][m] = hamiltonian(n: n+1, m: m+1, L: L, hbar: hbar, mass: mass)
            }
        }
        
        return H
    }
    func diagonalize(matrix: [[Double]]) -> (eigenvalues: [Double], eigenvectors: [[Double]]) {
        let N = matrix.count
        var A = matrix
        var eigenvectors = Array(repeating: Array(repeating: 0.0, count: N), count: N)
        var eigenvalues = Array(repeating: 0.0, count: N)
        
        var nrot = 0
        
        while nrot < 50 {
            nrot += 1
            var sum = 0.0
            for i in 0..<N-1 {
                for j in i+1..<N {
                    sum += abs(A[i][j])
                }
            }
            if sum == 0 {
                break
            }
            
            for p in 0..<N-1 {
                for q in p+1..<N {
                    let app = A[p][p]
                    let apq = A[p][q]
                    let aqq = A[q][q]
                    let phi = 0.5 * atan2(2*apq, aqq-app)
                    let c = cos(phi)
                    let s = sin(phi)
                    for r in 0..<N {
                        let arp = A[r][p]
                        let arq = A[r][q]
                        A[r][p] = c*arp + s*arq
                        A[r][q] = -s*arp + c*arq
                        let erp = eigenvectors[r][p]
                        let erq = eigenvectors[r][q]
                        eigenvectors[r][p] = c*erp + s*erq
                        eigenvectors[r][q] = -s*erp + c*erq
                    }
                }
            }
        }
        
        for i in 0..<N {
            eigenvalues[i] = A[i][i]
        }
        
        return (eigenvalues: eigenvalues, eigenvectors: eigenvectors)
    }
}
