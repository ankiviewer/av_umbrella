module Spinner exposing (spinner)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


spinner : Bool -> Html msg
spinner visible =
    let
        display =
            if visible then
                "db"
            else
                "dn"
    in
        div [ class ("spinner " ++ display) ]
            [ div [ class "sk-circle" ]
                (List.range 1 12
                    |> List.map (\n -> div [ class ("sk-circle" ++ (toString n) ++ " sk-child") ] [])
                )
            ]
