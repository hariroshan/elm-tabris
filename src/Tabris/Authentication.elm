module Tabris.Authentication exposing (..)

import Json.Decode as D


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


name : String
name =
    "m-auth"


type Method
    = Authenticate { status : Status, message : String }
    | CanAuthenticate Bool
    | Cancel


availableBiometrics : String
availableBiometrics =
    "availableBiometrics"


readAvailableBiometrics : ( String, String )
readAvailableBiometrics =
    ( name, availableBiometrics )


decodeProps : D.Decoder Props
decodeProps =
    D.oneOf
        [ D.field availableBiometrics (D.list (decodeSupportedBiometrics))
            |> D.map AvailableBiometrics
        ]
