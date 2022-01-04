import { config } from '@formidablejs/framework/lib/Support/Helpers'
import { mix } from '@formidablejs/framework/lib/Support/Helpers'
import { View } from '@formidablejs/framework'

export class App < View

	def render
		<html[h:100% bg:gray1] lang=get('locale', config('app.locale', new String)).replace(/_/g, '-')>
			<head>
				<meta charset='utf-8' />
				<meta name='viewport' content='width=device-width,initial-scale=1' />

				# fonts
				<link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap'>

				# styles
				<style src='./app'>
				<style src=mix('/css/app.css')>

				# scripts
				<script src=mix('/js/app.js') defer>

			<body[m:0 ff:Nunito]>
				<div id='app' data-page=get('dataPage')>
