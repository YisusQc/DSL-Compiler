#include "ast.hpp"
#include <fstream>

void generateCode(ProgramNode* program) {
    std::ofstream out("resultado.cpp");

    out << "#include <iostream>\n\n";

    for (auto& instr : program->instructions) {

        if (auto fn = dynamic_cast<FunctionNode*>(instr.get())) {
            out << fn->returnType << " " << fn->name << "(";

            for (size_t i = 0; i < fn->params.size(); ++i) {
                out << "int " << fn->params[i];
                if (i + 1 < fn->params.size()) out << ", ";
            }

            out << ") {\n    return 0;\n}\n\n";
        }

        if (dynamic_cast<MainFunctionNode*>(instr.get())) {
            out << "int main() {\n    return 0;\n}\n";
        }
    }
}
