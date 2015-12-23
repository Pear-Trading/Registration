<?php include_once( 'const.php'); ?>
<div class="header_container">

  <div class="navbar">

    <div class="container">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-responsive-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>

      <div class="nav-collapse navbar-responsive-collapse collapse">
        <a class="pull-left" href="#">
          <img src="<? echo BASE_URL; ?>/images/pear_logo.png" alt="logo" id="logo" />
        </a>
        <ul class="nav navbar-nav dropdown">
          <li><a href="<? echo BASE_URL; ?>/blog/">Blog</a></li>
          <li><a href="<? echo BASE_URL; ?>/work/">What we working on?</a></li>
          <li><a href="<? echo BASE_URL; ?>/about/get-involved/">Get Involved</a></li>
          <li><a href="<? echo BASE_URL; ?>/contact/">Contact</a></li>
          <li><a title="log-in" href="<? echo BASE_URL; ?>/registration/">Sign up</a></li>
          <li><a title="log-in" href="<? echo BASE_URL; ?>/portal/">Log in</a></li>
        </ul>

      </div><!-- /.nav-collapse -->
    </div><!-- /.container -->
  </div><!-- /.navbar -->
</div>
