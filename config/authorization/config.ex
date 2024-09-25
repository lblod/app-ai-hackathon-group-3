alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    # These elements are walked from top to bottom.  Each of them may
    # alter the quads to which the current query applies.  Quads are
    # represented in three sections: current_source_quads,
    # removed_source_quads, new_quads.  The quads may be calculated in
    # many ways.  The useage of a GroupSpec and GraphCleanup are
    # common.
    [
      # // PUBLIC
      %GroupSpec{
        name: "public",
        useage: [:read, :write, :read_for_write],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "https://id.erfgoed.net/vocab/ontology#Aanduidingsobject",
                        "https://id.erfgoed.net/vocab/ontology#Besluit",
                        "https://id.erfgoed.net/vocab/ontology#Plan",
                        "https://id.erfgoed.net/vocab/ontology#Dossier",
                        "https://id.erfgoed.net/vocab/ontology#Poststuk",
                        "http://www.w3.org/ns/adms#Identifier",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#RemoteDataObject"

                      ]
                    } } ] },

      # // CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end
