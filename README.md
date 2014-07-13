# Three Buses

> "You wait for ages, then three turn up at once"

This is a webapp to display live bus times. This powers [University of York live buses](http://uoyb.us) and is now easily-configurable for other such routes covered by multiple buses.

## Usage
This is built to work on Ruby 1.9+.

```
git clone https://github.com/46bit/threebuses.git
cd threebuses
bundle install
cp credentials.sample.yml credentials.yml
```

Register at [TransportAPI](https://developer.transportapi.com) then add your details to `credentials.yml`.

Run the server using `rackup`.

## Configuration
Until there's an easy-configuration program, you'll need to manually edit `route.yml` using the comments as a guide. Make sure to reboot the server after changes.

## About
Built by [Michael Mokrysz](https://46b.it) with contributions from [DinCahill](https://github.com/DinCahill). Data sourced from TransportAPI. Licensed under MIT.
