module Tabris.Authentication exposing
    ( AuthOptions(..)
    , Method(..)
    , Props(..)
    , Status(..)
    , SupportedBiometrics(..)
    , decodeMethods
    , decodeProps
    , methodAuthenticate
    , methodCanAuthenticate
    , methodCancel
    , readAvailableBiometrics, tagName
    )

import Array exposing (Array)
import Json.Decode as D
import Json.Encode as E
import Tabris.Common exposing (decodeResult)


type SupportedBiometrics
    = FingerPrint
    | Face


decodeSupportedBiometrics : D.Decoder SupportedBiometrics
decodeSupportedBiometrics =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "fingerprint" ->
                        D.succeed FingerPrint

                    "face" ->
                        D.succeed Face

                    _ ->
                        D.fail ("unknown biometric" ++ str)
            )


type Props
    = AvailableBiometrics (List SupportedBiometrics)


type Status
    = Success
    | Canceled
    | UserCanceled
    | LimitExceeded
    | Lockout
    | BiometricsNotEnrolled
    | CredentialsNotEnrolled
    | Error


type AuthOptions
    = Title String -- The title shown in the authentication ui. optional
    | SubTitle String -- The subtitle shown in the authentication ui. optional
    | Message String -- The message shown in the authentication ui. optional
    | AllowCredentials Bool -- Configure whether to allow another authentication mechanism other than biometric authentication. For example, when a fingerprint would be the device default, the user could choose to fallback to use a pin instead. When non-biometric credentials are used, no fallback is available. . defaults to true
    | ConfirmationRequired Bool -- When a fast authentication mechanism like face unlock is used, this option allows to configure whether a successful authorization has to be confirmed by the user via a button press. defaults to true


tagName : String
tagName =
    "m-auth"


type Method
    = Authenticate (Result String { status : Status, message : Maybe String })
    | CanAuthenticate Bool
    | Cancel


methodAuthenticate : List AuthOptions -> ( String, String, Array D.Value )
methodAuthenticate authOptions =
    ( tagName
    , authenticate
    , authOptions
        |> List.map
            (\d ->
                case d of
                    Title title ->
                        ( "title", E.string title )

                    SubTitle subTitle ->
                        ( "subTitle", E.string subTitle )

                    Message msg ->
                        ( "message", E.string msg )

                    AllowCredentials bool ->
                        ( "allowCredentials", E.bool bool )

                    ConfirmationRequired bool ->
                        ( "confirmationRequired", E.bool bool )
            )
        |> E.object
        |> List.singleton
        |> Array.fromList
    )


canAuthenticate : String
canAuthenticate =
    "canAuthenticate"


methodCanAuthenticate : Maybe Bool -> ( String, String, Array E.Value )
methodCanAuthenticate maybeAllowCredientials =
    ( tagName
    , authenticate
    , maybeAllowCredientials
        |> Maybe.map
            (\value -> E.object [ ( "allowCredentials", E.bool value ) ] |> List.singleton |> Array.fromList)
        |> Maybe.withDefault Array.empty
    )


availableBiometrics : String
availableBiometrics =
    "availableBiometrics"


authenticate : String
authenticate =
    "authenticate"


cancel : String
cancel =
    "cancel"


methodCancel : ( String, String, Array E.Value )
methodCancel =
    ( tagName, cancel, Array.empty )


readAvailableBiometrics : ( String, String )
readAvailableBiometrics =
    ( tagName, availableBiometrics )


decodeProps : D.Decoder Props
decodeProps =
    D.oneOf
        [ D.field availableBiometrics (D.list decodeSupportedBiometrics)
            |> D.map AvailableBiometrics
        ]


decodeStatus : D.Decoder Status
decodeStatus =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "success" ->
                        D.succeed Success

                    "canceled" ->
                        D.succeed Canceled

                    "userCanceled" ->
                        D.succeed UserCanceled

                    "limitExceeded" ->
                        D.succeed LimitExceeded

                    "lockout" ->
                        D.succeed Lockout

                    "biometricsNotEnrolled" ->
                        D.succeed BiometricsNotEnrolled

                    "credentialsNotEnrolled" ->
                        D.succeed CredentialsNotEnrolled

                    "Error" ->
                        D.succeed Error

                    _ ->
                        D.fail ("Unknown status" ++ str)
            )


decodeMethods : D.Decoder Method
decodeMethods =
    D.oneOf
        [ D.field authenticate
            (decodeResult
                { ok =
                    D.map2 (\status msg -> { status = status, message = msg })
                        (D.field "status" decodeStatus)
                        (D.maybe (D.field "message" D.string))
                , err = D.string
                }
                |> D.map Authenticate
            )
        , D.field canAuthenticate D.bool |> D.map CanAuthenticate
        , D.field cancel (D.null Cancel)
        ]
