#pragma once
#include <string>
#include <vector>
#include <memory>

struct ASTNode {
    virtual ~ASTNode() = default;
};

/* ===== PROGRAMA ===== */

struct ProgramNode : ASTNode {
    std::vector<std::unique_ptr<ASTNode>> instructions;
};

/* ===== FUNCIONES ===== */

struct FunctionNode : ASTNode {
    std::string returnType;
    std::string name;
    std::vector<std::string> params;
};

struct MainFunctionNode : ASTNode {
};


void generateCode(ProgramNode* program);

