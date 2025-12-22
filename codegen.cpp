#include "ast.hpp"
#include <fstream>

/* ===== PROGRAMA ===== */

void ProgramNode::generate(std::ostream& out) {
    out << "#include <iostream>\n\n";
    for (auto& instr : instructions)
        instr->generate(out);
}

/* ===== BLOQUES ===== */

void BlockNode::generate(std::ostream& out) {
    for (auto& stmt : statements)
        stmt->generate(out);
}

/* ===== FUNCIONES ===== */

void FunctionNode::generate(std::ostream& out) {
    out << returnType << " " << name << "(";

    for (size_t i = 0; i < params.size(); ++i) {
        out << "int " << params[i];
        if (i + 1 < params.size()) out << ", ";
    }

    out << ") {\n";
    if (body) body->generate(out);
    out << "}\n\n";
}

void MainFunctionNode::generate(std::ostream& out) {
    out << "int main() {\n";
    if (body) body->generate(out);
    out << "    return 0;\n}\n";
}

/* ===== VARIABLES ===== */

void VarDeclNode::generate(std::ostream& out) {
    out << type << " " << name << ";\n";
}

void AssignNode::generate(std::ostream& out) {
    out << name << " = " << value << ";\n";
}

/* ===== PRINT ===== */

void PrintNode::generate(std::ostream& out) {
    out << "std::cout << \"" << text << "\" << std::endl;\n";
}

/* ===== BUCLES ===== */

void ForNode::generate(std::ostream& out) {
    out << "for(int i=" << start << "; i<=" << end << "; ++i) {\n";
    body->generate(out);
    out << "}\n";
}

