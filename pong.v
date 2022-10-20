module main

import sdl

const (
	title      = 'Pong Game!'
	win_width  = 800
	win_height = 500
)

struct Paddle {
pub mut:
	x int
	y int
}

struct Ball {
pub mut:
	x  int
	y  int
	dx int
	dy int
}

struct SdlContext {
pub mut:
	a        string
	window   &sdl.Window   = sdl.null
	renderer &sdl.Renderer = sdl.null
}

enum GameState {
	init
	main_menu
	paused
	running
	gameover
}

struct Game {
pub mut:
	state GameState
	sdl   SdlContext
	pad1  Paddle
	pad2  Paddle
}

fn (mut g Game) initialize_game() ? {
	if sdl.init(sdl.init_video) >= 0 {
		// if sucess
		g.sdl.window = sdl.create_window(title.str, sdl.windowpos_centered, sdl.windowpos_centered,
			win_width, win_height, 0)
		if g.sdl.window != 0 {
			g.sdl.renderer = sdl.create_renderer(g.sdl.window, -1, u32(sdl.RendererFlags.accelerated) | u32(sdl.RendererFlags.presentvsync))
		}
	g.state = .main_menu
	} else {} // sdl could not initialize
}

fn (mut g Game) main_menu() ? {
	mut close_game := false
	for {
		evt := sdl.Event{}
		for 0 < sdl.poll_event(&evt) {
			match evt.@type {
				.quit { close_game = true }
				else {}
			}
		}
		if close_game {
			break
		}

		sdl.set_render_draw_color(g.sdl.renderer, 0, 0, 0, 255)
		sdl.render_clear(g.sdl.renderer)
		sdl.render_present(g.sdl.renderer)
	}
	sdl.destroy_renderer(g.sdl.renderer)
	sdl.destroy_window(g.sdl.window)
	sdl.quit()
}

fn main() {
	mut game := &Game{
		state: .init
	}
	if game.state == .init {
		game.initialize_game() or { panic(err) }
	}
	if game.state == .main_menu {
		game.main_menu() or { panic(err) }
		
	}
}
