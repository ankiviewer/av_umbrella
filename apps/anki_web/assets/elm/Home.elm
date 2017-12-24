module Home exposing (..)

import Html exposing (Html, h3, h4, div, button, img, text)
import Html.Attributes exposing (id, class, src)

main
  = Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

type alias Model =
  { updatedAt : String
  , syncing : Bool
  }

init : ( Model, Cmd Msg )
init = ( initialModel, Cmd.none )

initialModel : Model
initialModel =
  { updatedAt = "..."
  , syncing = False
  }

type Msg
  = M

view : Model -> Html Msg
view model = div []
  [ h3 [] [ text "Last Updated:" ]
  , h4 [] [ text "8:00 24 Dec 2017" ]
  , button [ id "sync_button", class "dib pa2 bg-light-grey br3" ] [ img [ src "/images/reload.svg" ] [] ]
  , div [] [ text "spinner" ]
  ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
