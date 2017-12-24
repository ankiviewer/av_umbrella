port module Home exposing (..)

import Html exposing (Html, h3, h4, div, button, img, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class, src)
import Http
import Json.Decode as Decode

import Spinner exposing (spinner)

main : Program Never Model Msg
main
  = Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

type alias Model =
  { updatedAt : String
  , syncHappening: Bool
  , syncMessage : String
  }

init : ( Model, Cmd Msg )
init = ( initialModel, fetchDeck )

initialModel : Model
initialModel =
  { updatedAt = ""
  , syncHappening = False
  , syncMessage = ""
  }

fetchDeck : Cmd Msg
fetchDeck =
  let
    request =
      Http.get "/api/deck" decodeData
  in
     Http.send Deck request

type Msg
  = FetchDeck String
  | Deck (Result Http.Error String)
  | Sync
  | SyncMessage String

view : Model -> Html Msg
view model = div []
  [ h3 [] [ text "Last Updated:" ]
  , h4 [] [ text model.updatedAt ]
  , button [
      id "sync_button",
      class "dib pa2 bg-light-grey br3",
      (onClick Sync)
      ]
      [ img [ src "/images/reload.svg" ] [] ]
  , div [ class "mv3" ]
    [ spinner model.syncHappening
    , syncDiv model.syncHappening model.syncMessage
    ]
  ]

syncDiv : Bool -> String -> Html msg
syncDiv visible message =
  let
    display = if visible then "db" else "dn"
  in
    div [ class (display ++ " mv2") ] [ text message ]

decodeData : Decode.Decoder String
decodeData =
  Decode.at ["payload"] Decode.string

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FetchDeck url ->
      ( model, fetchDeck )
    Deck (Ok updatedAt) ->
      ({ model | updatedAt = updatedAt }, Cmd.none)
    Deck (Err _) ->
      (model, Cmd.none)
    Sync ->
      ({ model | syncHappening = True }, sync "deck" )
    SyncMessage syncMessage ->
      let
        syncHappening = syncMessage /= "Synced!"
      in
        ({ model | syncMessage = syncMessage, syncHappening = syncHappening }, Cmd.none )

port sync : String -> Cmd msg

port syncMessage : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model
  = syncMessage SyncMessage
