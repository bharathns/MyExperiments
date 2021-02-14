{
  "targets": [
    {
      "target_name": "appShare",
      "cflags!": [ "-fno-exceptions" ],
      "cflags_cc!": [ "-fno-exceptions" ],
      #"sources": [ "./native/mac/appshare_napi.cc" ],
      "include_dirs": [
        "<!@(node -p \"require('node-addon-api').include\")"
      ],
      'defines': [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ],
      'conditions': [
        ['OS=="mac"', {
        'xcode_settings': {
            'OTHER_CFLAGS': [
                '-ObjC++'
                ]
            },
        'sources': [
            "./native/mac/appshare_napi.cc"
            ]
        }],
        ['OS=="win"', {
         'sources': [
            "./native/win/appshare_napi.cc"
            ]
        }]
      ]
    }
  ]
}
