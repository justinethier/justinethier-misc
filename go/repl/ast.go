

package gosql

type Ast struct {
    Statements []*Statement
}

A statement, for now, is one of INSERT, CREATE, or SELECT:

type AstKind uint

const (
    SelectKind AstKind = iota
    CreateTableKind
    InsertKind
)

type Statement struct {
    SelectStatement      *SelectStatement
    CreateTableStatement *CreateTableStatement
    InsertStatement      *InsertStatement
    Kind                 AstKind
}

INSERT

An insert statement, for now, has a table name and a list of values to insert:

type InsertStatement struct {
    table  token
    values *[]*expression
}

An expression is a literal token or (in the future) a function call or inline operation:

type expressionKind uint

const (
    literalKind expressionKind = iota
)

type expression struct {
    literal *token
    kind    expressionKind
}

CREATE

A create statement, for now, has a table name and a list of column names and types:

type columnDefinition struct {
    name     token
    datatype token
}

type CreateTableStatement struct {
    name token
    cols *[]*columnDefinition
}

SELECT

A select statement, for now, has a table name and a list of column names:

type SelectStatement struct {
    item []*expression
    from token
}
