# autoslider_error class

autoslider_error class

## Usage

``` r
autoslider_error(x, spec, step)
```

## Arguments

- x:

  character scaler

- spec:

  spec should be a list containing "program" and "suffix"

- step:

  step is a character indicating in which step the pipeline encounter
  error

## Value

autoslider_error object

## Details

this function is used to create autoslider_error object. this function
is for internal use only to create the autoslider_error object. It
enable us for further functionalities, like providing help on easy
debugging, e.g. if the error is inside the user function, provide the
call and let the user run the code outside the pipeline.
