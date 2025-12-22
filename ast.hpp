#pragma once
#include <string>
#include <vector>
#include <memory>
#include <ostream>

/* ===== BASE ===== */

struct ASTNode {
    virtual ~ASTNode() = default;
    virtual void generate(std::ostream& out) = 0;
};

/* ===== PROGRAMA ===== */

struct ProgramNode : ASTNode {
    std::vector<std::unique_ptr<ASTNode>> instructions;
    void generate(std::ostream& out) override;
};

/* ===== BLOQUES ===== */

struct StatementNode : ASTNode {};

struct BlockNode : ASTNode {
    std::vector<std::unique_ptr<StatementNode>> statements;
    void generate(std::ostream& out) override;
};

/* ===== FUNCIONES ===== */

struct FunctionNode : ASTNode {
    std::string returnType;
    std::string name;
    std::vector<std::string> params;
    std::unique_ptr<BlockNode> body;

    void generate(std::ostream& out) override;
};

struct MainFunctionNode : ASTNode {
    std::unique_ptr<BlockNode> body;
    void generate(std::ostream& out) override;
};

/* ===== VARIABLES ===== */

struct VarDeclNode : StatementNode {
    std::string type;
    std::string name;
    void generate(std::ostream& out) override;
};

struct AssignNode : StatementNode {
    std::string name;
    std::string value;
    void generate(std::ostream& out) override;
};

/* ===== IMPRIMIR ===== */

struct PrintNode : StatementNode {
    std::string text;
    void generate(std::ostream& out) override;
};

/* ===== BUCLES ===== */

struct ForNode : StatementNode {
    int start;
    int end;
    std::unique_ptr<BlockNode> body;
    void generate(std::ostream& out) override;
};

